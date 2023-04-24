// To parse this JSON data, do
//
//     final couponApplyResponse = couponApplyResponseFromJson(jsonString);

import 'dart:convert';

CouponApplyResponse couponApplyResponseFromJson(String str) => CouponApplyResponse.fromJson(json.decode(str));

String couponApplyResponseToJson(CouponApplyResponse data) => json.encode(data.toJson());

class CouponApplyResponse {
  CouponApplyResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory CouponApplyResponse.fromJson(Map<String, dynamic> json) => CouponApplyResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}