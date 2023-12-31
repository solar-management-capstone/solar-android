import 'dart:math';

import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';
import 'package:mobile_solar_mp/features/package_product/service/package_product_service.dart';
import 'package:mobile_solar_mp/models/bracket.dart';
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
  late String firstHalfDescription;
  late String secondHalfDescription;
  bool isShowMoreDescription = true;

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
    if (package.description!.length > 100) {
      setState(() {
        firstHalfDescription = package.description!.substring(0, 100);
        secondHalfDescription =
            package.description!.substring(100, package.description!.length);
      });
    } else {
      setState(() {
        firstHalfDescription = package.description!;
        secondHalfDescription = "";
      });
    }
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
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationBarApp(
              pageIndex: widget.index,
            ),
          ),
        );
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
          onPressed: () => Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBarApp(
                pageIndex: widget.index,
              ),
            ),
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
                    package.presentImage != null
                        ? Column(children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.network(
                                package.presentImage!,
                                height: 200,
                              ),
                            ),
                            const SizedBox(height: 10.0)
                          ])
                        : const SizedBox(),
                    Text(
                      package.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diện tích mái: ~${package.roofArea}m2',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Hoá đơn điện: ~${formatCurrency(package.electricBill!)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Mô tả:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    secondHalfDescription.isEmpty
                        ? Container(
                            color: Colors.grey[200],
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${package.description}'),
                          )
                        : Container(
                            color: Colors.grey[200],
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(isShowMoreDescription
                                    ? '$firstHalfDescription ...'
                                    : '$firstHalfDescription + $secondHalfDescription'),
                                InkWell(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        isShowMoreDescription
                                            ? "xem thêm"
                                            : "hiện ít hơn",
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isShowMoreDescription =
                                          !isShowMoreDescription;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                    package.promotion != null
                        ? const SizedBox(height: 10.0)
                        : const SizedBox(),
                    package.promotion != null
                        ? Text(
                            'Giảm giá từ ngày ${formatDate(package.promotion!.startDate!)} đến ngày ${formatDate(package.promotion!.endDate!)}',
                            style: const TextStyle(color: Colors.red),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Danh sách sản phẩm:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: listPackageProduct.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildProductWidget(
                          listPackageProduct[index].product!,
                          listPackageProduct[index].quantity!,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10.0),
                    ),
                    // const SizedBox(height: 10.0),
                    // const Text(
                    //   'Khung đỡ:',
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold, fontSize: 16.0),
                    // ),
                    // const SizedBox(height: 10.0),
                    // ListView.separated(
                    //   scrollDirection: Axis.vertical,
                    //   itemCount: listPackageProduct.length,
                    //   shrinkWrap: true,
                    //   physics: const ClampingScrollPhysics(),
                    //   itemBuilder: (BuildContext context, int index) {
                    //     listPackageProduct[index].bracket != null
                    //         ? _buildBracketWidget(
                    //             listPackageProduct[index].bracket!,
                    //           )
                    //         : null;
                    //     return null;
                    //   },
                    //   separatorBuilder: (context, index) =>
                    //       const SizedBox(height: 10.0),
                    // ),
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
            color: Colors.grey[200],
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationBarApp(
                        pageIndex: 3,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Chat',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleSendRequest(''),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Gửi yêu cầu tư vấn',
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white70,
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
              _buildQuantityIconStar(feedback.rating!),
              Text(
                feedback.description!.length > 40
                    ? '${feedback.description!.substring(0, 40)}...'
                    : feedback.description!,
              )
            ],
          ),
          Text(
            formatDateTime(feedback.createAt!),
          )
        ],
      ),
    );
  }

  Widget _buildQuantityIconStar(int length) {
    List<Widget> icons = List.generate(
      length,
      (index) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );

    return Row(
      children: icons,
    );
  }

  Widget _buildProductWidget(Product product, int quantity) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
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
            'Nhà sản xuất: ${product.manufacturer}',
          ),
          const SizedBox(height: 10.0),
          Text(
            'Tính năng: ${product.feature}',
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thời gian bảo hành: ${formatDate(product.warrantyDate!)}',
              ),
              Text('x$quantity')
            ],
          ),
          // const SizedBox(height: 10.0),
          // Text(
          //   formatCurrency(product.price!),
          //   style: const TextStyle(
          //     color: Colors.red,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildBracketWidget(Bracket bracket) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Text(
            bracket.name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Nhà sản xuất: ${bracket.manufacturer}',
          ),
          const SizedBox(height: 10.0),
          Text(
            'Vật liệu: ${bracket.material}',
          ),
          const SizedBox(height: 10.0),
          Text(
            'Kích thước: ${bracket.size}',
          ),
          // const SizedBox(height: 10.0),
          // Text(
          //   formatCurrency(bracket.price!),
          //   style: const TextStyle(
          //     color: Colors.red,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }
}
