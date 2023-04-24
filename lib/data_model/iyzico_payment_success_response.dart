// To parse this JSON data, do
//
//     final iyzicoPaymentSuccessResponse = iyzicoPaymentSuccessResponseFromJson(jsonString);

import 'dart:convert';

IyzicoPaymentSuccessResponse iyzicoPaymentSuccessResponseFromJson(String str) => IyzicoPaymentSuccessResponse.fromJson(json.decode(str));

String iyzicoPaymentSuccessResponseToJson(IyzicoPaymentSuccessResponse data) => json.encode(data.toJson());

class IyzicoPaymentSuccessResponse {
  IyzicoPaymentSuccessResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory IyzicoPaymentSuccessResponse.fromJson(Map<String, dynamic> json) => IyzicoPaymentSuccessResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}