// To parse this JSON data, do
//
//     final bkashBeginResponse = bkashBeginResponseFromJson(jsonString);

import 'dart:convert';

BkashBeginResponse bkashBeginResponseFromJson(String str) => BkashBeginResponse.fromJson(json.decode(str));

String bkashBeginResponseToJson(BkashBeginResponse data) => json.encode(data.toJson());

class BkashBeginResponse {
  BkashBeginResponse({
    this.token,
    this.result,
    this.url,
    this.message,
  });

  String token;
  bool result;
  String url;
  String message;

  factory BkashBeginResponse.fromJson(Map<String, dynamic> json) => BkashBeginResponse(
    token: json["token"],
    result: json["result"],
    url: json["url"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "result": result,
    "url": url,
    "message": message,
  };
}