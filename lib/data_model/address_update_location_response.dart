// To parse this JSON data, do
//
//     final addressUpdateLocationResponse = addressUpdateLocationResponseFromJson(jsonString);

import 'dart:convert';

AddressUpdateLocationResponse addressUpdateLocationResponseFromJson(String str) => AddressUpdateLocationResponse.fromJson(json.decode(str));

String addressUpdateLocationResponseToJson(AddressUpdateLocationResponse data) => json.encode(data.toJson());

class AddressUpdateLocationResponse {
  AddressUpdateLocationResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory AddressUpdateLocationResponse.fromJson(Map<String, dynamic> json) => AddressUpdateLocationResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}