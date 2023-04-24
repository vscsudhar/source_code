// To parse this JSON data, do
//
//     final flutterwaveUrlResponse = flutterwaveUrlResponseFromJson(jsonString);

import 'dart:convert';

FlutterwaveUrlResponse flutterwaveUrlResponseFromJson(String str) => FlutterwaveUrlResponse.fromJson(json.decode(str));

String flutterwaveUrlResponseToJson(FlutterwaveUrlResponse data) => json.encode(data.toJson());

class FlutterwaveUrlResponse {
  FlutterwaveUrlResponse({
    this.result,
    this.url,
    this.message,
  });

  bool result;
  String url;
  String message;

  factory FlutterwaveUrlResponse.fromJson(Map<String, dynamic> json) => FlutterwaveUrlResponse(
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