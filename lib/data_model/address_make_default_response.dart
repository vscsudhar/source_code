// To parse this JSON data, do
//
//     final addressMakeDefaultResponse = addressMakeDefaultResponseFromJson(jsonString);

import 'dart:convert';

AddressMakeDefaultResponse addressMakeDefaultResponseFromJson(String str) => AddressMakeDefaultResponse.fromJson(json.decode(str));

String addressMakeDefaultResponseToJson(AddressMakeDefaultResponse data) => json.encode(data.toJson());

class AddressMakeDefaultResponse {
  AddressMakeDefaultResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory AddressMakeDefaultResponse.fromJson(Map<String, dynamic> json) => AddressMakeDefaultResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}