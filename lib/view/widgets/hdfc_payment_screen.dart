import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../theme/constants.dart';

class HdfcPaymentScreen extends StatelessWidget {
  final String paymentUrl; // you get this from your backend

  const HdfcPaymentScreen({super.key, required this.paymentUrl});

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains(
              "${StringConstants.baseUrl}/payment/payment-success",
            )) {
              Navigator.pop(context, "success");
            } else if (request.url.contains(
              "${StringConstants.baseUrl}/payment/payment-failure",
            )) {
              Navigator.pop(context, "failed");
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
    return Scaffold(
      appBar: AppBar(title: Text("Complete Payment", style: t500_16)),
      body: WebViewWidget(controller: controller),
      // body: WebViewWidget(
      //   initialUrl: paymentUrl,
      //   javascriptMode: JavascriptMode.unrestricted,
      //   navigationDelegate: (request) {
      //     if (request.url.contains("yourdomain.com/payment-success")) {
      //       Navigator.pop(context, "success");
      //     } else if (request.url.contains("yourdomain.com/payment-failed")) {
      //       Navigator.pop(context, "failed");
      //     }
      //     return NavigationDecision.navigate;
      //   },
      // ),
    );
  }
}
