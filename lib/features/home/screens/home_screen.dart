import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
//import 'package:mobile_solar_mp/common/widgets/custom_button.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/home/service/home_service.dart';
import 'package:mobile_solar_mp/features/package_product/screens/package_product_screen.dart';
import 'package:mobile_solar_mp/models/package.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = RoutePath.homeRoute;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> listImageSlider = [
    "https://media.baodautu.vn/Images/huutuan/2022/11/30/QC1.jpg",
    "https://kenh14cdn.com/203336854389633024/2021/6/1/anh-chup-man-hinh-2021-06-01-luc-190139-16225506660211157797993-16225506948101621046346.png"
  ];

  // double _currentSliderRoofAreaValue = 0;
  // double _currentSliderElectricBillValue = 1000000;

  late Future<List<Package>> packages = [] as Future<List<Package>>;

  Future<List<Package>> getPackages() async {
    List<Package> packages = [];
    try {
      packages = await HomeService().getPackages(context: context);
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
    super.initState();
    packages = getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trang chủ',
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: listImageSlider.length,
                itemBuilder: (context, index, realIndex) {
                  return _buildImageSlider(listImageSlider[index], index);
                },
                options: CarouselOptions(height: 150, autoPlay: true),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Các gói được chọn nhiều nhất',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              // Text(
              //   'Diện tích mái nhà tối thiểu: ${_currentSliderRoofAreaValue.round().toString()} m2',
              //   style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
              // Slider(
              //   value: _currentSliderRoofAreaValue,
              //   max: 200,
              //   divisions: 10,
              //   label: _currentSliderRoofAreaValue.round().toString(),
              //   onChanged: (double value) {
              //     setState(() {
              //       _currentSliderRoofAreaValue = value;
              //     });
              //   },
              // ),
              // const SizedBox(height: 16.0),
              // Text(
              //   'Hoá đơn tiền điện trung bình hàng tháng: ${formatCurrency(_currentSliderElectricBillValue)}',
              //   style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
              // Slider(
              //   value: _currentSliderElectricBillValue,
              //   max: 10000000,
              //   divisions: 100000,
              //   min: 100000,
              //   label: formatCurrency(_currentSliderElectricBillValue),
              //   onChanged: (double value) {
              //     setState(() {
              //       _currentSliderElectricBillValue = value;
              //     });
              //   },
              // ),
              // CustomButton(
              //     text: 'Tìm kiếm',
              //     onTap: () {
              //       setState(() {
              //         packages = getPackages();
              //       });
              //     }),
              // const SizedBox(
              //   height: 16.0,
              // ),
              FutureBuilder<List<Package>>(
                future: packages,
                builder: (BuildContext build, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
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
    );
  }
}

Widget _buildImageSlider(String urlImage, int index) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    child: Image.network(
      urlImage,
      fit: BoxFit.cover,
    ),
  );
}

Widget _buildRow(BuildContext context, Package item) {
  return InkWell(
    onTap: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PackageProductScreen(
            package: item,
            index: 0,
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
                  ? Image.network(item.presentImage!, width: 100.0,)
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
              Text(
                'Diện tích mái nhà: ${item.roofArea}',
              ),
              Text(
                'Hoá đơn tiền điện: ${item.roofArea}',
              ),
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
                      style: const TextStyle(color: Colors.red, fontSize: 16.0),
                    )
                  ],
                )
              else
                Text(
                  formatCurrency(item.price!),
                  style: const TextStyle(color: Colors.red, fontSize: 16.0),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
