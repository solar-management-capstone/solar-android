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
    "https://www.dnxenergy.com.au/wp-content/uploads/2019/04/Yanchep_4-181012-4.jpg",
    "https://solarfvengenharia.com/wp-content/uploads/2022/11/dscf0693-760x520.jpg",
    "https://fujita-ec.com/wp-content/uploads/2019/05/bao-gia-nang-luong-mat-troi.jpg",
    "https://insenergy.vn/Data/Sites/1/News/256/hybrid.jpeg",
    "https://i1-sohoa.vnecdn.net/2021/11/18/170671421-2786909764881471-689-8869-7575-1637214806.jpg?w=680&h=0&q=100&dpr=2&fit=crop&s=CF4uOdVPs_ZPEYWoT9Ysdg",
    "https://zsvsolar.com/wp-content/uploads/lap-dien-nang-luong-mat-troi-ap-mai-ha-noi.jpg",
    "https://suntechsolar.vn/wp-content/uploads/2019/04/dien-mat-troi-ho-gia-dinh.jpg",
    "https://imagev3.vietnamplus.vn/w660/Uploaded/2023/ngtnnn/2020_08_10/TTXVN_1008dienMT.jpg",
    "https://vogiasolar.com/wp-content/uploads/2016/08/dien-mat-troi-4-1.jpg",
    "https://nhathongminhvietsun.com/wp-content/uploads/2020/02/Dien-mat-troi-gia-dinh-1.jpg"
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
              const Divider(),
              // const SizedBox(height: 16.0),
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PackageProductScreen(
            package: item,
            index: 0,
          ),
        ),
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
              Align(
                alignment: Alignment.center,
                child: item.presentImage != null
                    ? Image.network(
                        item.presentImage!,
                        height: 60.0,
                      )
                    : const SizedBox(),
              ),
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
