import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/construction_contract/screens/feedback_screen.dart';
import 'package:mobile_solar_mp/features/construction_contract/service/construction_contract_service.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/construction_contract_detail_screen.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';

class ConstructionContractScreen extends StatefulWidget {
  static const String routeName = RoutePath.constructionContractRoute;
  const ConstructionContractScreen({super.key});

  @override
  State<ConstructionContractScreen> createState() =>
      _ConstructionContractScreenState();
}

class _ConstructionContractScreenState extends State<ConstructionContractScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<ConstructionContract>> listConstructionContract =
      [] as Future<List<ConstructionContract>>;

  late TabController _tabController;

  List<Widget> listTab = const [
    Tab(text: 'Thông tin'),
    Tab(text: 'Đã huỷ'),
  ];

  Future<List<ConstructionContract>> getConstructionContractByStatus(
      {required int status}) async {
    List<ConstructionContract> listConstructionContract = [];
    try {
      listConstructionContract =
          await ConstructionContractService().getConstructionContractByStatus(
        context: context,
        status: status,
      );
    } on CustomException catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.toString(),
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

    return listConstructionContract;
  }

  @override
  void initState() {
    super.initState();
    listConstructionContract = getConstructionContractByStatus(status: 2);

    _tabController = TabController(length: listTab.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hợp đồng'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          onTap: (index) {
            setState(
              () {
                int status = 2;
                if (index == 0) {
                  status = 2;
                } else if (index == 1) {
                  status = 0;
                }
                listConstructionContract =
                    getConstructionContractByStatus(status: status);
              },
            );
          },
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: listTab,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: listTab
            .map(
              (e) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<List<ConstructionContract>>(
                    future: listConstructionContract,
                    builder: (BuildContext build, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        List<ConstructionContract> constructionContract =
                            snapshot.data;
                        if (constructionContract.isEmpty) {
                          return const Center(
                            child: Text('Không có hợp đồng'),
                          );
                        }
                        // return GridView.builder(
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        //   itemCount: constructionContract.length,
                        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 1,
                        //     crossAxisSpacing: 12.0,
                        //     mainAxisSpacing: 12.0,
                        //   ),
                        //   itemBuilder: (context, int index) {
                        //     return _buildContract(context, constructionContract[index]);
                        //   },
                        // );
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: constructionContract.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildContract(
                              context,
                              constructionContract[index],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget _buildContract(
  BuildContext context,
  ConstructionContract constructionContract,
) {
  return InkWell(
    onTap: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ConstructionContractDetailScreen(
            constructionContract: constructionContract,
            index: 2,
          ),
        ),
        (route) => false,
      );
    },
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      height: 110.0,
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
              // Text(
              //   'Tên nhân viên: ${constructionContract.staff?.firstname} ${constructionContract.staff?.lastname}',
              // ),
              // Text(
              //   constructionContract.bracket!.name!.length > 40
              //       ? 'Khung đỡ: ${constructionContract.bracket!.name!.substring(0, 40)}...'
              //       : 'Khung đỡ: ${constructionContract.bracket?.name}',
              // ),
              Text(
                constructionContract.package!.name!.length > 100
                    ? 'Gói: ${constructionContract.package!.name!.substring(0, 100)}...'
                    : 'Gói: ${constructionContract.package?.name}',
              ),
              Row(
                children: [
                  const Text(
                    'Giá trị hợp đồng: ',
                  ),
                  Text(
                    formatCurrency(constructionContract.totalcost!),
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Thời hạn HĐ ',
                  ),
                  Text(
                    'từ ${formatDate(constructionContract.startdate!)}',
                  ),
                  const Text(' '),
                  Text(
                    'đến ${formatDate(constructionContract.enddate!)}',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Trạng thái: ',
                      ),
                      constructionContract.status == '0'
                          ? const Text(
                              'Đã huỷ',
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox(),
                      constructionContract.status == '1'
                          ? const Text(
                              'Chờ duyệt',
                              style: TextStyle(color: Colors.green),
                            )
                          : const SizedBox(),
                      constructionContract.status == '2'
                          ? const Text(
                              'Hoạt động',
                              style: TextStyle(color: Colors.blue),
                            )
                          : const SizedBox(),
                      constructionContract.status == '3'
                          ? const Text(
                              'Hoàn thành',
                              style: TextStyle(color: Colors.deepPurple),
                            )
                          : const SizedBox()
                    ],
                  ),
                  // constructionContract.status == '3'
                  //     ? ElevatedButton(
                  //         onPressed: () => Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (_) => FeedbackScreen(
                  //               constructionContract: constructionContract,
                  //             ),
                  //           ),
                  //         ),
                  //         style: ElevatedButton.styleFrom(
                  //           minimumSize: const Size(20, 20),
                  //           backgroundColor: Colors.white,
                  //           side: const BorderSide(color: Colors.red),
                  //           shadowColor: Colors.grey,
                  //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         ),
                  //         child: const Text(
                  //           'Đánh giá',
                  //           style: TextStyle(color: Colors.red),
                  //         ),
                  //       )
                  //     : const SizedBox(),
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
}
