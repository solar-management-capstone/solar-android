import 'dart:math';

import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/construction_contract/screens/feedback_screen.dart';
import 'package:mobile_solar_mp/features/construction_contract/service/construction_contract_service.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/web_view_container.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/service/construction_contract_detail_service.dart';
import 'package:mobile_solar_mp/features/history_construction_contract/screens/history_construction_contract.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';
import 'package:mobile_solar_mp/models/acceptance.dart';
import 'package:mobile_solar_mp/models/bracket.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';
import 'package:mobile_solar_mp/models/payment.dart';
import 'package:mobile_solar_mp/models/product.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';

class ConstructionContractDetailScreen extends StatefulWidget {
  static const String routeName = RoutePath.constructionContractDetailRoute;
  ConstructionContract? constructionContract;
  bool? isReloadData;
  // navigation bar index
  final int? index;
  ConstructionContractDetailScreen({
    super.key,
    this.constructionContract,
    this.index,
    this.isReloadData = false,
  });

  @override
  State<ConstructionContractDetailScreen> createState() =>
      ConstructionContractDetailScreenState(
        constructionContract: constructionContract!,
        index: index,
        isReloadData: isReloadData!,
      );
}

class ConstructionContractDetailScreenState
    extends State<ConstructionContractDetailScreen> {
  ConstructionContract constructionContract;
  int? index;
  bool isReloadData;
  // List<Payment> payment = [];

  ConstructionContractDetailScreenState({
    required this.constructionContract,
    this.index,
    required this.isReloadData,
  });

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

  @override
  void initState() {
    super.initState();

    if (widget.isReloadData == true) {
      ConstructionContractDetailService()
          .getConstructionContractById(
        context: context,
        constructionContractId:
            widget.constructionContract!.constructioncontractId!,
      )
          .then((value) {
        setState(() {
          constructionContract = value;
          isReloadData = false;
        });
      });
    }

    // _handleGetPayment();
  }

  // void _handleGetPayment() async {
  //   List<Payment> paymentResponse =
  //       await ConstructionContractDetailService().getPayment(
  //     context: context,
  //     constructionContractId:
  //         widget.constructionContract!.constructioncontractId!,
  //   );

  //   setState(() {
  //     payment = paymentResponse;
  //   });
  // }

  void _handlePayment({
    required String constructionContractId,
  }) async {
    try {
      Payment payment = await ConstructionContractDetailService().createPayment(
        context: context,
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
                constructionContract: widget.constructionContract!,
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
    // ConstructionContract constructionContract = widget.constructionContract!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hợp đồng'),
        leading: IconButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBarApp(
                pageIndex: 2,
              ),
            ),
            (route) => false,
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: isReloadData
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mã hợp đồng: ${constructionContract.constructioncontractId}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Nhân viên:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      width: 1.0,
                                      color: Colors.black54,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                child: constructionContract.status == '0'
                                    ? const Text(
                                        'Đã huỷ',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : constructionContract.status == '1'
                                        ? const Text(
                                            'Chờ duyệt',
                                            style:
                                                TextStyle(color: Colors.green),
                                          )
                                        : constructionContract.status == '2' &&
                                                DateTime.parse(
                                                            constructionContract
                                                                .startdate!)
                                                        .compareTo(
                                                      DateTime.now(),
                                                      // ) <
                                                    ) >=
                                                    0
                                            ? const Text(
                                                'Hợp đồng mới',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            : constructionContract.status ==
                                                        '2' &&
                                                    DateTime.parse(
                                                                constructionContract
                                                                    .startdate!)
                                                            .compareTo(
                                                          DateTime.now(),
                                                          // ) >=
                                                        ) <
                                                        0
                                                ? const Text(
                                                    'Đang thi công',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )
                                                : constructionContract.status ==
                                                        '3'
                                                    ? const Text(
                                                        'Hoàn tất',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .deepPurple),
                                                      )
                                                    : const SizedBox(),
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                          Text(
                            'Thông tin gói: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${constructionContract.package?.name}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  // 'Mô tả: ${constructionContract.package?.description}',
                                  '\n${constructionContract.package?.description}',
                                ),
                                // Wrap(
                                //   children: [
                                //     if (constructionContract.package?.promotion !=
                                //         null)
                                //       Wrap(
                                //         children: [
                                //           Row(
                                //             children: [
                                //               const Text('Giá: '),
                                //               Text(
                                //                 constructionContract.package?.price !=
                                //                         null
                                //                     ? formatCurrency(
                                //                         constructionContract
                                //                             .package!.price!,
                                //                       )
                                //                     : 'null',
                                //                 style: const TextStyle(
                                //                   decoration:
                                //                       TextDecoration.lineThrough,
                                //                 ),
                                //               ),
                                //               const Text(' '),
                                //               Text(
                                //                 '${constructionContract.package?.promotion?.amount.toString().replaceAll('.0', '')}%',
                                //               ),
                                //               Text(
                                //                 constructionContract.package
                                //                             ?.promotionPrice !=
                                //                         null
                                //                     ? ' ${formatCurrency(
                                //                         constructionContract
                                //                             .package!.promotionPrice!,
                                //                       )}'
                                //                     : 'null',
                                //                 style: const TextStyle(
                                //                     color: Colors.red,
                                //                     fontSize: 16.0),
                                //               )
                                //             ],
                                //           ),
                                //         ],
                                //       )
                                //     else
                                //       Row(
                                //         children: [
                                //           const Text(
                                //             'Giá trị hợp đồng: ',
                                //           ),
                                //           Text(
                                //             formatCurrency(
                                //                 constructionContract.package!.price!),
                                //             style: const TextStyle(color: Colors.red),
                                //           ),
                                //         ],
                                //       ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Danh sách sản phẩm:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: constructionContract
                                .package!.packageProduct!.length,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return _buildProductWidget(
                                constructionContract
                                    .package!.packageProduct![index].product!,
                                constructionContract
                                    .package!.packageProduct![index].quantity!,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8.0),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Khung đỡ:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          _buildBracketWidget(
                            constructionContract.bracket!,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Giá trị hợp đồng: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                formatCurrency(constructionContract.totalcost!),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          if (constructionContract.paymentProcess?.length !=
                                  null &&
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
                                          borderRadius:
                                              BorderRadius.circular(16.0),
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
                                ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return _buildAcceptance(
                                      constructionContract.acceptance![index],
                                    );
                                  },
                                  itemCount:
                                      constructionContract.acceptance!.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10.0),
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 16.0),
                                //   child: Column(
                                //     children: [
                                //       Row(
                                //         children: [
                                //           const Text('Mô tả đánh giá: '),
                                //           Text(constructionContract
                                //                   .acceptance?[0].feedback ??
                                //               ''),
                                //         ],
                                //       ),
                                //       _buildQuantityIconStar(
                                //         constructionContract.acceptance![0].rating!,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            'Thời hạn hợp đồng từ ngày: ${formatDate(constructionContract.startdate!)} đến ngày: ${formatDate(constructionContract.enddate!)}',
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Text(
                            'Liên hệ hỗ trợ: 0909643365',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
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
                if (constructionContract.status == '2' &&
                    constructionContract.paymentProcess?.length == 1 &&
                    constructionContract.paymentProcess?[0].isDeposit == true &&
                    constructionContract.paymentProcess?[0].status == 'Paid')
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () => _handlePayment(
                        constructionContractId:
                            constructionContract.constructioncontractId!,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Đặt cọc',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else if (constructionContract.status == '2' &&
                    constructionContract.paymentProcess?.length == 1)
                  const SizedBox()
                else if (constructionContract.status == '2')
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () => _handlePayment(
                        constructionContractId:
                            constructionContract.constructioncontractId!,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Đặt cọc',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                if (constructionContract.status == '3' &&
                    constructionContract.paymentProcess?.length == 1 &&
                    constructionContract.paymentProcess?[0].isDeposit == true &&
                    constructionContract.paymentProcess?[0].status == 'success')
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () => _handlePayment(
                        constructionContractId:
                            constructionContract.constructioncontractId!,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Tất toán',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else if (constructionContract.status == '3' &&
                    constructionContract.paymentProcess?.length == 2 &&
                    constructionContract.paymentProcess?[0].payDate == null &&
                    constructionContract.paymentProcess?[0].isDeposit ==
                        false &&
                    constructionContract.paymentProcess?[0].status == 'Paid')
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () => _handlePayment(
                        constructionContractId:
                            constructionContract.constructioncontractId!,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Tất toán',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else if (constructionContract.status == '3' &&
                    constructionContract.paymentProcess?.length == 2 &&
                    constructionContract.paymentProcess?[1].payDate == null &&
                    constructionContract.paymentProcess?[1].isDeposit ==
                        false &&
                    constructionContract.paymentProcess?[1].status == 'Paid')
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () => _handlePayment(
                        constructionContractId:
                            constructionContract.constructioncontractId!,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Tất toán',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else if (constructionContract.status == '3' &&
                    constructionContract.paymentProcess?.length == 2 &&
                    constructionContract.paymentProcess?[0].payDate != null &&
                    constructionContract.paymentProcess?[0].isDeposit ==
                        true &&
                    constructionContract.paymentProcess?[0].status ==
                        'success' &&
                    constructionContract.paymentProcess?[1].payDate != null &&
                    constructionContract.paymentProcess?[1].isDeposit ==
                        false &&
                    constructionContract.paymentProcess?[1].status ==
                        'success' &&
                    constructionContract.feedback!.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeedbackScreen(
                            constructionContract: constructionContract,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Đánh giá',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else if (constructionContract.status == '3' &&
                    constructionContract.paymentProcess?.length == 2 &&
                    constructionContract.paymentProcess?[0].payDate != null &&
                    constructionContract.paymentProcess?[0].isDeposit ==
                        false &&
                    constructionContract.paymentProcess?[0].status ==
                        'success' &&
                    constructionContract.paymentProcess?[1].payDate != null &&
                    constructionContract.paymentProcess?[1].isDeposit ==
                        true &&
                    constructionContract.paymentProcess?[1].status ==
                        'success' &&
                    constructionContract.feedback!.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeedbackScreen(
                            constructionContract: constructionContract,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Đánh giá',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox()
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
//                     tag: 'image-${Random().nextInt(1000)}',
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
                ),
              ],
            ),
            constructionContract.paymentProcess![index].status == 'Paid' &&
                    constructionContract.paymentProcess![index].isDeposit ==
                        true
                ? const Text(
                    ' (Thanh toán chưa thành công)',
                    style: TextStyle(color: Colors.red),
                  )
                : const Text(''),
            constructionContract.paymentProcess![index].status == 'Paid' &&
                    constructionContract.paymentProcess![index].isDeposit ==
                        false
                ? const Text(
                    ' (Thanh toán chưa thành công)',
                    style: TextStyle(color: Colors.red),
                  )
                : const Text('')
          ],
        );
      },
    ),
  );
}

Widget _buildAcceptance(Acceptance acceptance) {
  return Container(
    // color: Colors.grey[200],
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 100.0,
        child: FullScreenWidget(
          disposeLevel: DisposeLevel.High,
          child: Center(
            child: Hero(
              tag: {acceptance.imageFile},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  acceptance.imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
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
                      tag: 'image-${Random().nextInt(1000)}',
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
        // const SizedBox(height: 10.0),
        // Text(
        //   'Tính năng: ${product.feature}',
        // ),
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
        SizedBox(
          height: bracket.image!.isNotEmpty ? 200.0 : 0,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: bracket.image?.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.only(right: 10.0),
                child: FullScreenWidget(
                  disposeLevel: DisposeLevel.High,
                  child: Center(
                    child: Hero(
                      tag: 'image-${Random().nextInt(1000)}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          bracket.image![index].imageData!,
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
          'Kích thước: ${bracket.size} m2',
        ),
      ],
    ),
  );
}
