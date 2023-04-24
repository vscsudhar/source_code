// To parse this JSON data, do
//
//     final confirmCodeResponse = confirmCodeResponseFromJson(jsonString);

import 'dart:convert';

CommonResponse commonResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));

String commonResponseToJson(CommonResponse data) => json.encode(data.toJson());

class CommonResponse {
  CommonResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}