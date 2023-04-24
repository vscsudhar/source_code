// To parse this JSON data, do
//
//     final passwordConfirmResponse = passwordConfirmResponseFromJson(jsonString);

import 'dart:convert';

PasswordConfirmResponse passwordConfirmResponseFromJson(String str) => PasswordConfirmResponse.fromJson(json.decode(str));

String passwordConfirmResponseToJson(PasswordConfirmResponse data) => json.encode(data.toJson());

class PasswordConfirmResponse {
  PasswordConfirmResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory PasswordConfirmResponse.fromJson(Map<String, dynamic> json) => PasswordConfirmResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}