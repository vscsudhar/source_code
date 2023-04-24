// To parse this JSON data, do
//
//     final couponRemoveResponse = couponRemoveResponseFromJson(jsonString);

import 'dart:convert';

CouponRemoveResponse couponRemoveResponseFromJson(String str) => CouponRemoveResponse.fromJson(json.decode(str));

String couponRemoveResponseToJson(CouponRemoveResponse data) => json.encode(data.toJson());

class CouponRemoveResponse {
  CouponRemoveResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory CouponRemoveResponse.fromJson(Map<String, dynamic> json) => CouponRemoveResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}