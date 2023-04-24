import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:active_ecommerce_flutter/data_model/payment_type_response.dart';
import 'package:active_ecommerce_flutter/data_model/order_create_response.dart';
import 'package:active_ecommerce_flutter/data_model/paypal_url_response.dart';
import 'package:active_ecommerce_flutter/data_model/flutterwave_url_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/data_model/razorpay_payment_success_response.dart';
import 'package:active_ecommerce_flutter/data_model/paystack_payment_success_response.dart';
import 'package:active_ecommerce_flutter/data_model/iyzico_payment_success_response.dart';
import 'package:active_ecommerce_flutter/data_model/bkash_begin_response.dart';
import 'package:active_ecommerce_flutter/data_model/bkash_payment_process_response.dart';
import 'package:active_ecommerce_flutter/data_model/nagad_begin_response.dart';
import 'package:active_ecommerce_flutter/data_model/nagad_payment_process_response.dart';

import 'package:active_ecommerce_flutter/data_model/sslcommerz_begin_response.dart';

class PaymentRepository {
  Future<dynamic> getPaymentResponseList(
      {mode = "", list = "both"}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/payment-types?mode=${mode}&list=${list}");

    print("getPaymentResponseList url " + url.toString());

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return paymentTypeResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponse(
      @required payment_method) async {
    var post_body = jsonEncode({"payment_type": "${payment_method}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/order/store");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return orderCreateResponseFromJson(response.body);
  }

  Future<PaypalUrlResponse> getPaypalUrlResponse(@required String payment_type,
      @required int combined_order_id, @required var package_id, @required double amount) async {
    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/paypal/payment/url?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id",
    );
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    //print(response.body.toString());
    return paypalUrlResponseFromJson(response.body);
  }

  Future<FlutterwaveUrlResponse> getFlutterwaveUrlResponse(
      @required String payment_type,
      @required int combined_order_id,
      @required var package_id,
      @required double amount) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/flutterwave/payment/url?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    //print(url);
    //print(response.body.toString());
    return flutterwaveUrlResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromWallet(
      @required payment_method, @required double amount) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/payments/pay/wallet");

    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}",
      "amount": "${amount}"
    });

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return orderCreateResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromCod(
      @required payment_method) async {
    var post_body = jsonEncode(
        {"user_id": "${user_id.$}", "payment_type": "${payment_method}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/payments/pay/cod");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return orderCreateResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromManualPayment(
      @required payment_method) async {
    var post_body = jsonEncode(
        {"user_id": "${user_id.$}", "payment_type": "${payment_method}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/payments/pay/manual");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return orderCreateResponseFromJson(response.body);
  }

  Future<RazorpayPaymentSuccessResponse> getRazorpayPaymentSuccessResponse(
      @required payment_type,
      @required double amount,
      @required int combined_order_id,
      @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    //print(post_body.toString());

    Uri url = Uri.parse("${AppConfig.BASE_URL}/razorpay/success");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    //print(response.body.toString());
    return razorpayPaymentSuccessResponseFromJson(response.body);
  }

  Future<PaystackPaymentSuccessResponse> getPaystackPaymentSuccessResponse(
      @required payment_type,
      @required double amount,
      @required int combined_order_id,
      @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/paystack/success");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    //print(response.body.toString());
    return paystackPaymentSuccessResponseFromJson(response.body);
  }

  Future<IyzicoPaymentSuccessResponse> getIyzicoPaymentSuccessResponse(
      @required payment_type,
      @required double amount,
      @required int combined_order_id,
      @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/paystack/success");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    //print(response.body.toString());
    return iyzicoPaymentSuccessResponseFromJson(response.body);
  }

  Future<BkashBeginResponse> getBkashBeginResponse(
      @required String payment_type,
      @required int combined_order_id,
      @required var package_id,
      @required double amount) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/bkash/begin?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=${package_id}");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );

    print(response.body.toString());
    return bkashBeginResponseFromJson(response.body);
  }

  Future<BkashPaymentProcessResponse> getBkashPaymentProcessResponse(
      @required payment_type,
      @required double amount,
      @required int combined_order_id,
      @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/bkash/api/process");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
        },
        body: post_body);

    //print(response.body.toString());
    return bkashPaymentProcessResponseFromJson(response.body);
  }

  Future<SslcommerzBeginResponse> getSslcommerzBeginResponse(
      @required String payment_type,
      @required int combined_order_id,
      @required var package_id,
      @required double amount) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/sslcommerz/begin?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    print(response.body.toString());
    return sslcommerzBeginResponseFromJson(response.body);
  }

  Future<NagadBeginResponse> getNagadBeginResponse(
      @required String payment_type,
      @required int combined_order_id,
      @required var package_id,
      @required double amount) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/nagad/begin?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    print(response.body.toString());
    return nagadBeginResponseFromJson(response.body);
  }

  Future<NagadPaymentProcessResponse> getNagadPaymentProcessResponse(
      @required payment_type,
      @required double amount,
      @required int combined_order_id,
      @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/nagad/process");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
        },
        body: post_body);

    //print(response.body.toString());
    return nagadPaymentProcessResponseFromJson(response.body);
  }
}
