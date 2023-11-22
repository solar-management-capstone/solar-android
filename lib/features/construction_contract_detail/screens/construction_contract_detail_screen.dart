import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/web_view_container.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/service/construction_contract_detail_service.dart';
import 'package:mobile_solar_mp/features/history_construction_contract/screens/history_construction_contract.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';
import 'package:mobile_solar_mp/models/payment.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';

class ConstructionContractDetailScreen extends StatefulWidget {
  static const String routeName = RoutePath.constructionContractDetailRoute;
  final ConstructionContract? constructionContract;
  // navigation bar index
  final int? index;
  const ConstructionContractDetailScreen({
    super.key,
    this.constructionContract,
    this.index,
  });

  @override
  State<ConstructionContractDetailScreen> createState() =>
      ConstructionContractDetailScreenState();
}

class ConstructionContractDetailScreenState
    extends State<ConstructionContractDetailScreen> {
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

  // void _handleSendRequest(String description) async {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   try {
  //     await PackageProductService().createRequest(
  //       context: context,
  //       description: description,
  //       packageId: widget.package!.packageId!,
  //     );
  //     if (mounted) {
  //       showSnackBar(context, 'Gửi yêu cầu tư vấn thành công');
  //       Navigator.pop(context);
  //     }
  //   } on CustomException catch (e) {
  //     if (mounted) {
  //       showSnackBar(
  //         context,
  //         e.cause,
  //         color: Colors.red,
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       showSnackBar(
  //         context,
  //         e.toString(),
  //         color: Colors.red,
  //       );
  //     }
  //   }
  // }

  void _handlePayment({
    required double amount,
    required String constructionContractId,
  }) async {
    try {
      Payment payment = await ConstructionContractDetailService().createPayment(
        context: context,
        amount: amount,
        constructionContractId: constructionContractId,
        accountId: SharedPreferencesUtils.getId()!,
      );

      if (mounted) {
        String url = await ConstructionContractDetailService().getUrlVnPay(
          context: context,
          paymentId: payment.paymentId!,
        );

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewContainer(
                url: url,
              ),
            ),
          );
        }
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

  void _handleCancelConstructionContract(String constructionContractId) async {
    try {
      await ConstructionContractDetailService().cancelConstructionContract(
        context: context,
        constructionContractId: constructionContractId,
      );
      if (mounted) {
        showSnackBar(
          context,
          'Huỷ hợp đồng thành công',
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => NavigationBarApp(
              pageIndex: 2,
            ),
          ),
          (route) => false,
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
    ConstructionContract constructionContract = widget.constructionContract!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hợp đồng'),
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.index != null
                  ? NavigationBarApp(
                      pageIndex: 2,
                    )
                  : const HistoryConstructionContractScreen(),
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
                    const Text(
                      'Nhân viên:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '   ${constructionContract.staff?.firstname} ${constructionContract.staff?.lastname}'),
                          Text(
                            '   Số điện thoại: ${constructionContract.staff?.phone}',
                          ),
                          Text(
                            '   Email: ${constructionContract.staff?.email}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text(
                      'Khung đỡ:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${constructionContract.bracket?.name}'),
                          Row(
                            children: [
                              const Text('Giá: '),
                              Text(
                                formatCurrency(
                                    constructionContract.bracket!.price!),
                                style: const TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          Text(
                            'Nhà sản xuất: ${constructionContract.bracket?.manufacturer}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text(
                      'Gói:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${constructionContract.package?.name}'),
                          Text(
                            'Mô tả: ${constructionContract.package?.description}',
                          ),
                          Wrap(
                            children: [
                              if (constructionContract.package?.promotion !=
                                  null)
                                Wrap(
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Giá: '),
                                        Text(
                                          constructionContract.package?.price !=
                                                  null
                                              ? formatCurrency(
                                                  constructionContract
                                                      .package!.price!,
                                                )
                                              : 'null',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const Text(' '),
                                        Text(
                                          '${constructionContract.package?.promotion?.amount.toString().replaceAll('.0', '')}%',
                                        ),
                                        Text(
                                          constructionContract.package
                                                      ?.promotionPrice !=
                                                  null
                                              ? ' ${formatCurrency(
                                                  constructionContract
                                                      .package!.promotionPrice!,
                                                )}'
                                              : 'null',
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    const Text(
                                      'Giá: ',
                                    ),
                                    Text(
                                      formatCurrency(
                                          constructionContract.package!.price!),
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (constructionContract.paymentProcess?.length != null &&
                        constructionContract.paymentProcess!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quá trình thanh toán:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _buildPaymentProcess(constructionContract),
                        ],
                      ),
                    if (constructionContract.imageFile != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hình ảnh hợp đồng:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 100.0,
                            child: FullScreenWidget(
                              disposeLevel: DisposeLevel.High,
                              child: Center(
                                child: Hero(
                                  tag: {constructionContract.imageFile},
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.network(
                                      constructionContract.imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (constructionContract.status == '3')
                      Wrap(
                        children: [
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Text(
                            'Nghiệm thu:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text('Mô tả đánh giá: '),
                                    Text(constructionContract
                                            .acceptance?[0].feedback ??
                                        ''),
                                  ],
                                ),
                                _buildQuantityIconStar(
                                  constructionContract.acceptance![0].rating!,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Hợp đồng từ ngày: ${formatDateTime(constructionContract.startdate!)} đến ngày: ${formatDateTime(constructionContract.enddate!)}',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () => _handlePayment(
          //         amount: constructionContract.totalcost!,
          //         constructionContractId:
          //             constructionContract.constructioncontractId!,
          //       ),
          //       style: ElevatedButton.styleFrom(
          //           minimumSize: const Size(150, 50),
          //           backgroundColor: Colors.white),
          //       child: const Text(
          //         'Thanh toán',
          //         style: TextStyle(
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {},
          //       style: ElevatedButton.styleFrom(
          //         minimumSize: const Size(150, 50),
          //       ),
          //       child: const Text(
          //         'Huỷ hợp đồng',
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ],
          // )

          if (constructionContract.status == '1')
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () => _handleCancelConstructionContract(
                  constructionContract.constructioncontractId!,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Huỷ hợp đồng',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          if (constructionContract.status == '2')
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () => _handlePayment(
                  amount: constructionContract.totalcost!,
                  constructionContractId:
                      constructionContract.constructioncontractId!,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildModal() {
  //   final TextEditingController descriptionController = TextEditingController();

  //   return Padding(
  //     padding:
  //         EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  //     child: Container(
  //       padding: const EdgeInsets.all(16.0),
  //       height: 250.0,
  //       child: Column(
  //         children: [
  //           const SizedBox(
  //             height: 20.0,
  //           ),
  //           CustomTextField(
  //             controller: descriptionController,
  //             hintText: 'Mô tả yêu cầu',
  //             maxLines: 2,
  //           ),
  //           const SizedBox(height: 16.0),
  //           CustomButton(
  //             text: 'Gửi yêu cầu',
  //             onTap: () => _handleSendRequest(descriptionController.text),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

// Widget _buildProductWidget(Product product) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       SizedBox(
//         height: product.image!.isNotEmpty ? 200.0 : 0,
//         width: double.infinity,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           shrinkWrap: true,
//           itemCount: product.image?.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Container(
//               padding: const EdgeInsets.only(right: 10.0),
//               child: FullScreenWidget(
//                 disposeLevel: DisposeLevel.High,
//                 child: Center(
//                   child: Hero(
//                     tag: 'image-${Random().nextInt(100)}',
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16.0),
//                       child: Image.network(
//                         product.image![index].imageData!,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       const SizedBox(height: 20.0),
//       Text(
//         product.name!,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 10.0),
//       Text(
//         formatCurrency(product.price!),
//         style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 20.0),
//     ],
//   );
// }

Widget _buildPaymentProcess(ConstructionContract constructionContract) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: constructionContract.paymentProcess?.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                    'Ngày: ${formatDateTime(constructionContract.paymentProcess![index].createAt!)}'),
                const Text(' Số tiền: '),
                Text(
                  formatCurrency(
                    constructionContract.paymentProcess![index].amount!,
                  ),
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
          ],
        );
      },
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