import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/providers/filter_package_provider.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';
import 'package:mobile_solar_mp/models/filter_package.dart';
import 'package:mobile_solar_mp/models/package.dart';
import 'package:provider/provider.dart';

class FilterPackageScreen extends StatefulWidget {
  static const String routeName = RoutePath.filterPackageRoute;
  const FilterPackageScreen({super.key});

  @override
  State<FilterPackageScreen> createState() => FilterPackageScreenState();
}

class FilterPackageScreenState extends State<FilterPackageScreen> {
  double _currentSliderRoofAreaValue = 0;
  double _currentSliderElectricBillValue = 1000000;

  late Future<List<Package>> packages = [] as Future<List<Package>>;

  @override
  void initState() {
    super.initState();

    FilterPackageProvider filterPackageProvider =
        Provider.of<FilterPackageProvider>(context, listen: false);
    if (filterPackageProvider.filterPackage.electricBill != null) {
      _currentSliderElectricBillValue =
          filterPackageProvider.filterPackage.electricBill!;
      _currentSliderRoofAreaValue =
          filterPackageProvider.filterPackage.roofArea!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bộ lọc',
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationBarApp(
                  pageIndex: 1,
                ),
              ),
              (route) => false),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Diện tích mái nhà tối thiểu: ${_currentSliderRoofAreaValue.round().toString()} m2',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _currentSliderRoofAreaValue,
                      max: 200,
                      divisions: 10,
                      label: _currentSliderRoofAreaValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderRoofAreaValue = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Hoá đơn tiền điện trung bình hàng tháng: ${formatCurrency(_currentSliderElectricBillValue)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _currentSliderElectricBillValue,
                      max: 10000000,
                      divisions: 100000,
                      min: 100000,
                      label: formatCurrency(_currentSliderElectricBillValue),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderElectricBillValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            // CustomButton(
            //   text: 'Tìm kiếm',
            //   onTap: () {
            //     final filterPackageProvider =
            //         Provider.of<FilterPackageProvider>(context, listen: false);
            //     filterPackageProvider.setFilterPackage(
            //       FilterPackage(
            //         roofArea: _currentSliderRoofAreaValue,
            //         electricBill: _currentSliderElectricBillValue,
            //       ),
            //     );
            //     Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => NavigationBarApp(
            //             pageIndex: 1,
            //           ),
            //         ),
            //         (route) => false);
            //   },
            // ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final filterPackageProvider =
                          Provider.of<FilterPackageProvider>(
                        context,
                        listen: false,
                      );
                      filterPackageProvider.setFilterPackage(
                        FilterPackage(
                          roofArea: null,
                          electricBill: null,
                        ),
                      );
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationBarApp(
                              pageIndex: 1,
                            ),
                          ),
                          (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 20,
                        50,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Xoá bộ lọc',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    final filterPackageProvider =
                        Provider.of<FilterPackageProvider>(
                      context,
                      listen: false,
                    );
                    filterPackageProvider.setFilterPackage(
                      FilterPackage(
                        roofArea: _currentSliderRoofAreaValue,
                        electricBill: _currentSliderElectricBillValue,
                      ),
                    );
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationBarApp(
                            pageIndex: 1,
                          ),
                        ),
                        (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width / 2 - 20, 50),
                  ),
                  child: const Text(
                    'Tìm kiếm',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
