import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/common/widgets/custom_button.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/construction_contract_detail_screen.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';

class NotifyPaymentFailedScreen extends StatelessWidget {
  static const String routeName = RoutePath.notifyPaymentFailedRoute;

  ConstructionContract? constructionContract;

  NotifyPaymentFailedScreen({
    super.key,
    this.constructionContract,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo thanh toán'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Thanh toán không thành công',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
              size: 100.0,
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: CustomButton(
                text: 'Quay về màn hình chi tiết hợp đồng',
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConstructionContractDetailScreen(
                      constructionContract: constructionContract,
                      isReloadData: true,
                    ),
                  ),
                  (route) => false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
