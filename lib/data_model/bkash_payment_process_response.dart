// To parse this JSON data, do
//
//     final bkashPaymentProcessResponse = bkashPaymentProcessResponseFromJson(jsonString);

import 'dart:convert';

BkashPaymentProcessResponse bkashPaymentProcessResponseFromJson(String str) => BkashPaymentProcessResponse.fromJson(json.decode(str));

String bkashPaymentProcessResponseToJson(BkashPaymentProcessResponse data) => json.encode(data.toJson());

class BkashPaymentProcessResponse {
  BkashPaymentProcessResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory BkashPaymentProcessResponse.fromJson(Map<String, dynamic> json) => BkashPaymentProcessResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}