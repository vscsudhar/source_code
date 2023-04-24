// To parse this JSON data, do
//
//     final refundRequestSendResponse = refundRequestSendResponseFromJson(jsonString);

import 'dart:convert';

RefundRequestSendResponse refundRequestSendResponseFromJson(String str) => RefundRequestSendResponse.fromJson(json.decode(str));

String refundRequestSendResponseToJson(RefundRequestSendResponse data) => json.encode(data.toJson());

class RefundRequestSendResponse {
  RefundRequestSendResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory RefundRequestSendResponse.fromJson(Map<String, dynamic> json) => RefundRequestSendResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}