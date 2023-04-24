// To parse this JSON data, do
//
//     final razorpayPaymentSuccessResponse = razorpayPaymentSuccessResponseFromJson(jsonString);

import 'dart:convert';

RazorpayPaymentSuccessResponse razorpayPaymentSuccessResponseFromJson(String str) => RazorpayPaymentSuccessResponse.fromJson(json.decode(str));

String razorpayPaymentSuccessResponseToJson(RazorpayPaymentSuccessResponse data) => json.encode(data.toJson());

class RazorpayPaymentSuccessResponse {
  RazorpayPaymentSuccessResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory RazorpayPaymentSuccessResponse.fromJson(Map<String, dynamic> json) => RazorpayPaymentSuccessResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}