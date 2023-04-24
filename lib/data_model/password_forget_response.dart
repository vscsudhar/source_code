// To parse this JSON data, do
//
//     final passwordForgetResponse = passwordForgetResponseFromJson(jsonString);

import 'dart:convert';

PasswordForgetResponse passwordForgetResponseFromJson(String str) => PasswordForgetResponse.fromJson(json.decode(str));

String passwordForgetResponseToJson(PasswordForgetResponse data) => json.encode(data.toJson());

class PasswordForgetResponse {
  PasswordForgetResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory PasswordForgetResponse.fromJson(Map<String, dynamic> json) => PasswordForgetResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}