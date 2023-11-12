import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/construction_contract_detail_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  static const String routeName = RoutePath.constructionContractDetailRoute;
  String? url;
  WebViewContainer({super.key, this.url});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState(url: url!);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final String url;
  _WebViewContainerState({required this.url});

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
          ..loadRequest(
            Uri.parse(url),
          ),
      ),
    );
  }
}
