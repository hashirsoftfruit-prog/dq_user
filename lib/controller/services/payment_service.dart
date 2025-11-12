import 'dart:convert';
import 'dart:developer';

import 'package:dqapp/controller/managers/booking_manager.dart';
import 'package:dqapp/model/helper/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';

class PaymentService {
  PaymentService._privateConstructor();
  static final PaymentService _instance = PaymentService._privateConstructor();
  static PaymentService get instance => _instance; // Global access point
  HyperSDK hyperSDK = HyperSDK();

  void initiatePayment(dynamic sdkPayLoad, String fromWhere) {
    hyperSDK.initiate(sdkPayLoad, hyperSDKCallbackHandler);
  }


  void hyperSDKCallbackHandler(MethodCall methodCall) {
    switch (methodCall.method) {
      case "hide_loader":
        break;
      case "process_result":
        var args = {};

        try {
          args = json.decode(methodCall.arguments);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        var innerPayload = args["payload"] ?? {};
        var status = innerPayload["status"] ?? " ";
        // var orderId = args['orderId'];

        switch (status) {
          case "backpressed":
            log("message is backpress status from payment service");

            getIt<BookingManager>().changePaymentProcessAndMessage(
              false,
              "User cancelled the payment",
            );
            break;

          case "charged":
            getIt<BookingManager>().changePaymentProcessAndMessage(
              false,
              "charged",
            );
            break;

          case "user_aborted":
            getIt<BookingManager>().changePaymentProcessAndMessage(
              false,
              "User cancelled the payment",
            );
            break;

          default:
            getIt<BookingManager>().changePaymentProcessAndMessage(
              false,
              "Something went wrong",
            );
            break;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const ResponseScreen(),
          //         settings: RouteSettings(arguments: orderId)));
        }
    }
  }
}

// final paymentService = PaymentService();
// paymentService.hyperSDK.openPaymentPage(sdkPayload, callbackHandler);
