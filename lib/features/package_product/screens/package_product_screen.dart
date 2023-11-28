import 'dart:math';

import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/common/widgets/custom_button.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';
import 'package:mobile_solar_mp/features/package_product/service/package_product_service.dart';
import 'package:mobile_solar_mp/models/feedback.dart' as feedback_model;
import 'package:mobile_solar_mp/models/package.dart';
import 'package:mobile_solar_mp/models/package_product.dart';
import 'package:mobile_solar_mp/models/product.dart';

class PackageProductScreen extends StatefulWidget {
  static const String routeName = RoutePath.packageProductRoute;
  final Package? package;
  final int? index;
  const PackageProductScreen({super.key, this.package, this.index});

  @override
  State<PackageProductScreen> createState() => _PackageProductScreenState();
}

class _PackageProductScreenState extends State<PackageProductScreen> {
  late Package package = widget.package!;
  late Future<List<feedback_model.Feedback>> feedbacks =
      [] as Future<List<feedback_model.Feedback>>;

  Future<List<feedback_model.Feedback>> _handleGetFeedbacksByPackageId() async {
    List<feedback_model.Feedback> feedbacks = [];
    try {
      feedbacks = await PackageProductService().getFeedbacksByPackageId(
        context: context,
        packageId: package.packageId!,
      );
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
    return feedbacks;
  }

  @override
  void initState() {
    super.initState();

    feedbacks = _handleGetFeedbacksByPackageId();
  }

  // void _openModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(8.0),
  //         topRight: Radius.circular(8.0),
  //       ),
  //     ),
  //     builder: (_) => _buildModal(),
  //   );
  // }

  void _handleSendRequest(String description) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await PackageProductService().createRequest(
        context: context,
        description: description,
        packageId: package.packageId!,
      );
      if (mounted) {
        showSnackBar(context, 'Gửi yêu cầu tư vấn thành công');
        // Navigator.pop(context);
      }
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
  }

  @override
  Widget build(BuildContext context) {
    List<PackageProduct> listPackageProduct = package.packageProduct ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gói sản phẩm'),
        leading: IconButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBarApp(
                pageIndex: widget.index,
              ),
            ),
            (route) => false,
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text('Mô tả: ${package.description}'),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diện tích mái nhà: ${package.roofArea}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Hoá đơn tiền điện: ${package.roofArea}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    package.promotion != null
                        ? Row(
                            children: [
                              Text(
                                '${formatCurrency(package.promotionPrice!)} ',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatCurrency(package.price!),
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                ' ${package.promotion?.amount.toString().replaceAll('.0', '')}%',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            formatCurrency(package.price ?? 0),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16.0,
                            ),
                          ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Giảm giá từ ngày ${formatDateTime(package.promotion!.startDate!)} đến ngày ${formatDateTime(package.promotion!.endDate!)}',
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
                          listPackageProduct[index].product!,
                        );
                      },
                    ),
                    const SizedBox(height: 10.0),
                    const Text('ĐÁNH GIÁ GÓI'),
                    const SizedBox(height: 10.0),
                    FutureBuilder<List<feedback_model.Feedback>>(
                      future: feedbacks,
                      builder: (BuildContext build, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          List<feedback_model.Feedback> feedbacks =
                              snapshot.data;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: feedbacks.length,
                            itemBuilder: (context, int index) {
                              return _buildRowFeedback(
                                context,
                                feedbacks[index],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationBarApp(pageIndex: 3,),
                    ),
                    (route) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Nhắn tin',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _handleSendRequest(''),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    'Gửi yêu cầu tư vấn',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

//   Widget _buildModal() {
//     final TextEditingController descriptionController = TextEditingController();

//     return Padding(
//       padding:
//           EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         height: 250.0,
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 20.0,
//             ),
//             CustomTextField(
//               controller: descriptionController,
//               hintText: 'Mô tả yêu cầu',
//               maxLines: 2,
//             ),
//             const SizedBox(height: 16.0),
//             CustomButton(
//               text: 'Gửi yêu cầu',
//               onTap: () => _handleSendRequest(descriptionController.text),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

  Widget _buildRowFeedback(
    BuildContext context,
    feedback_model.Feedback feedback,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      height: 80.0,
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
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${feedback.account!.username}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('${feedback.description}'),
            ],
          ),
          Text(
            formatDateTime(feedback.createAt!),
          )
        ],
      ),
    );
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
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
