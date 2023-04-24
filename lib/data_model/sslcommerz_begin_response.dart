// To parse this JSON data, do
//
//     final sslcommerzBeginResponse = sslcommerzBeginResponseFromJson(jsonString);

import 'dart:convert';

SslcommerzBeginResponse sslcommerzBeginResponseFromJson(String str) => SslcommerzBeginResponse.fromJson(json.decode(str));

String sslcommerzBeginResponseToJson(SslcommerzBeginResponse data) => json.encode(data.toJson());

class SslcommerzBeginResponse {
  SslcommerzBeginResponse({
    this.result,
    this.url,
    this.message,
  });

  bool result;
  String url;
  String message;

  factory SslcommerzBeginResponse.fromJson(Map<String, dynamic> json) => SslcommerzBeginResponse(
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