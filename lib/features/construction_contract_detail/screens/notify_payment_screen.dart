import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/common/widgets/custom_button.dart';
import 'package:mobile_solar_mp/constants/app_color.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';

class NotifyPaymentScreen extends StatelessWidget {
  static const String routeName = RoutePath.notifyPaymentRoute;
  const NotifyPaymentScreen({super.key});

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
              'Bạn đã thanh toán hợp đồng thành công',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Icon(
              Icons.check_circle,
              color: AppColor.primary,
              size: 100.0,
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: CustomButton(
                text: 'Quay về màn hình chính',
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarApp(
                      pageIndex: 0,
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
