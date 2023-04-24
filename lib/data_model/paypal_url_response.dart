// To parse this JSON data, do
//
//     final paypalUrlResponse = paypalUrlResponseFromJson(jsonString);

import 'dart:convert';

PaypalUrlResponse paypalUrlResponseFromJson(String str) => PaypalUrlResponse.fromJson(json.decode(str));

String paypalUrlResponseToJson(PaypalUrlResponse data) => json.encode(data.toJson());

class PaypalUrlResponse {
  PaypalUrlResponse({
    this.result,
    this.url,
    this.message,
  });

  bool result;
  String url;
  String message;

  factory PaypalUrlResponse.fromJson(Map<String, dynamic> json) => PaypalUrlResponse(
    result: json["result"],
    url: json["url"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "url": url,
    "message": message,
  };
}