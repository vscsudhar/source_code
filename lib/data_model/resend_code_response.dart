// To parse this JSON data, do
//
//     final resendCodeResponse = resendCodeResponseFromJson(jsonString);

import 'dart:convert';

ResendCodeResponse resendCodeResponseFromJson(String str) => ResendCodeResponse.fromJson(json.decode(str));

String resendCodeResponseToJson(ResendCodeResponse data) => json.encode(data.toJson());

class ResendCodeResponse {
  ResendCodeResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory ResendCodeResponse.fromJson(Map<String, dynamic> json) => ResendCodeResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}