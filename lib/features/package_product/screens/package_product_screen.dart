import 'dart:math';

import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:mobile_solar_mp/common/widgets/custom_button.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/models/package.dart';
import 'package:mobile_solar_mp/models/package_product.dart';
import 'package:mobile_solar_mp/models/product.dart';

class PackageProductScreen extends StatefulWidget {
  static const String routeName = RoutePath.packageProductRoute;
  final Package? package;
  const PackageProductScreen({super.key, this.package});

  @override
  State<PackageProductScreen> createState() => _PackageProductScreenState();
}

class _PackageProductScreenState extends State<PackageProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PackageProduct> listPackageProduct =
        widget.package?.packageProduct ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gói sản phẩm'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            RoutePath.homeRoute,
            (route) => false,
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.package!.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text('Mô tả: ${widget.package?.description}'),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diện tích mái nhà: ${widget.package?.roofArea}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Hoá đơn tiền điện: ${widget.package?.roofArea}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    widget.package?.promotion != null
                        ? Row(
                            children: [
                              Text(
                                '${formatCurrency(widget.package!.promotionPrice!)} ',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatCurrency(widget.package!.price!),
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                ' ${widget.package!.promotion?.amount.toString().replaceAll('.0', '')}%',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            formatCurrency(widget.package?.price ?? 0),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16.0,
                            ),
                          ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Giảm giá từ ngày ${formatDateTime(widget.package!.promotion!.startDate!)} đến ngày ${formatDateTime(widget.package!.promotion!.endDate!)}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Danh sách sản phẩm:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: listPackageProduct.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildProductWidget(
                            listPackageProduct[index].product!);
                      },
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(text: 'Yêu cầu tư vấn', onTap: () {})
          ],
        ),
      ),
    );
  }
}

Widget _buildProductWidget(Product product) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: product.image!.isNotEmpty ? 200.0 : 0,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: product.image?.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: FullScreenWidget(
                disposeLevel: DisposeLevel.High,
                child: Center(
                  child: Hero(
                    tag: 'image-${Random().nextInt(100)}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        product.image![index].imageData!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 20.0),
      Text(
        product.name!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10.0),
      Text(
        formatCurrency(product.price!),
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20.0),
    ],
  );
}
