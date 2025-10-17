import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  Razorpay? _razorpay;
  VoidCallback? onPaymentSuccessCallback;

  PaymentService({this.onPaymentSuccessCallback}) {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay!.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Payment Successful');
    if (onPaymentSuccessCallback != null) {
      onPaymentSuccessCallback!();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: ${response.code} - ${response.message!}",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'Payment Successful via Wallet');
    if (onPaymentSuccessCallback != null) {
      onPaymentSuccessCallback!();
    }
  }

  Future<void> openCheckout({
    required String price,
    required String orderId,
    required String userContact,
    required BuildContext context,
  }) async {
    var options = {
      'key': 'rzp_test_hCRLFPf6rY3elm',
      'order_id': orderId,
      'amount': (double.parse(price) * 100).toInt(),
      'name': 'AstroShree',
      'description': '',
      'image': 'https://admin.astroshri.in/images/logo.jpg',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': userContact,
      },
      'theme': {
        'color': '#F08080',
      },
      'external': {
        'wallets': ['paytm']
      },
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
