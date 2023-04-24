// To parse this JSON data, do
//
//     final paystackPaymentSuccessResponse = paystackPaymentSuccessResponseFromJson(jsonString);

import 'dart:convert';

PaystackPaymentSuccessResponse paystackPaymentSuccessResponseFromJson(String str) => PaystackPaymentSuccessResponse.fromJson(json.decode(str));

String paystackPaymentSuccessResponseToJson(PaystackPaymentSuccessResponse data) => json.encode(data.toJson());

class PaystackPaymentSuccessResponse {
  PaystackPaymentSuccessResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory PaystackPaymentSuccessResponse.fromJson(Map<String, dynamic> json) => PaystackPaymentSuccessResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}