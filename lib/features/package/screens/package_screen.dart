import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/config/providers/filter_package_provider.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/package/screens/filter_package_screen.dart';
import 'package:mobile_solar_mp/features/package/service/package_service.dart';
import 'package:mobile_solar_mp/features/package_product/screens/package_product_screen.dart';
import 'package:mobile_solar_mp/models/package.dart';
import 'package:provider/provider.dart';

class PackageScreen extends StatefulWidget {
  static const String routeName = RoutePath.packageRoute;
  // double? roofAreaValue;
  // double? electricBillValue;

  const PackageScreen({
    super.key,
    // this.electricBillValue,
    // this.roofAreaValue,
  });

  @override
  State<PackageScreen> createState() => PackageScreenState();
}

class PackageScreenState extends State<PackageScreen> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Package>> packages = [] as Future<List<Package>>;

  double _roofAreaValue = 0;
  double _electricBillValue = 1000000;

  Future<List<Package>> getPackages() async {
    List<Package> packages = [];
    try {
      packages = await PackageService().getPackages(
        context: context,
      );
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.toString(),
          color: Colors.red,
        );
      }
    }
    return packages;
  }

  Future<List<Package>> getPackagesFilter() async {
    List<Package> packages = [];
    try {
      packages = await PackageService().getPackagesFilter(
        context: context,
        roofArea: _roofAreaValue.toInt(),
        electricBill: _electricBillValue,
      );
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.toString(),
          color: Colors.red,
        );
      }
    }
    return packages;
  }

  Future<List<Package>> getPackagesByName() async {
    List<Package> packages = [];
    try {
      packages = await PackageService()
          .getPackagesByName(context: context, name: _searchController.text);
    } on CustomException catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.cause,
          color: Colors.red,
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.toString(),
          color: Colors.red,
        );
      }
    }
    return packages;
  }

  @override
  void initState() {
    FilterPackageProvider filterPackageProvider =
        Provider.of<FilterPackageProvider>(context, listen: false);
    if (filterPackageProvider.filterPackage.electricBill != null) {
      _electricBillValue = filterPackageProvider.filterPackage.electricBill!;
      _roofAreaValue = filterPackageProvider.filterPackage.roofArea!;

      packages = getPackagesFilter();
    } else {
      packages = getPackages();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _handleSearch() {
    if (_searchController.text != "") {
      setState(() {
        packages = getPackagesByName();
      });
    } else {
      setState(() {
        packages = getPackages();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        title: const Text(
          'Gói',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      controller: _searchController,
                      // obscureText: obscureText ?? false, // equal ? : expression
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => {
                            FocusManager.instance.primaryFocus?.unfocus(),
                            _handleSearch(),
                          },
                          icon: const Icon(Icons.search),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                        ),
                        labelText: 'Tên gói',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FilterPackageScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<List<Package>>(
                      future: packages,
                      builder: (BuildContext build, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          List<Package> packages = snapshot.data;
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: packages.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                            ),
                            itemBuilder: (context, int index) {
                              return _buildRow(context, packages[index]);
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget _buildImageSlider(String urlImage, int index) {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 12),
//     child: Image.network(
//       urlImage,
//       fit: BoxFit.cover,
//     ),
//   );
// }

Widget _buildRow(BuildContext context, Package item) {
  return InkWell(
    onTap: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PackageProductScreen(
            package: item,
            index: 1,
          ),
        ),
        (route) => false,
      );
    },
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.presentImage != null
                  ? Align(
                      alignment: Alignment.center,
                      child: Image.network(
                        item.presentImage!,
                        height: 60.0,
                      ),
                    )
                  : const SizedBox(),
              Text(
                item.name!.length > 50
                    ? '${item.name!.substring(0, 50)}...'
                    : item.name!,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Text(
              //   'Diện tích mái nhà: ${item.roofArea}',
              // ),
              // Text(
              //   'Hoá đơn tiền điện: ${item.roofArea}',
              // ),
            ],
          ),
          Wrap(
            children: [
              if (item.promotion != null)
                Wrap(
                  children: [
                    Row(
                      children: [
                        Text(
                          item.price != null
                              ? formatCurrency(item.price!)
                              : 'null',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const Text(' '),
                        Text(
                          '${item.promotion?.amount.toString().replaceAll('.0', '')}%',
                        )
                      ],
                    ),
                    Text(
                      item.promotionPrice != null
                          ? formatCurrency(item.promotionPrice!)
                          : 'null',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    )
                  ],
                )
              else
                Text(
                  formatCurrency(item.price!),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
