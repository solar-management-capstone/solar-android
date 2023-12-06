import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/construction_contract_detail_screen.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/notify_payment_screen.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  static const String routeName = RoutePath.constructionContractDetailRoute;
  String? url;
  ConstructionContract? constructionContract;
  WebViewContainer({
    super.key,
    this.url,
    this.constructionContract,
  });

  @override
  State<WebViewContainer> createState() => _WebViewContainerState(
        url: url!,
        constructionContract: constructionContract!,
      );
}

class _WebViewContainerState extends State<WebViewContainer> {
  final String url;
  ConstructionContract constructionContract;
  _WebViewContainerState({
    required this.url,
    required this.constructionContract,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {
                log(url);
              },
              onPageFinished: (String url) {
                log(url);
              },
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith(
                  'https://solar-caps.azurewebsites.net/api/VNPay/PaymentConfirm',
                )) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotifyPaymentScreen(
                        constructionContract: constructionContract,
                      ),
                    ),
                    (route) => false,
                  );
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
