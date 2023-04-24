// To parse this JSON data, do
//
//     final addressUpdateInCartResponse = addressUpdateInCartResponseFromJson(jsonString);

import 'dart:convert';

AddressUpdateInCartResponse addressUpdateInCartResponseFromJson(String str) => AddressUpdateInCartResponse.fromJson(json.decode(str));

String addressUpdateInCartResponseToJson(AddressUpdateInCartResponse data) => json.encode(data.toJson());

class AddressUpdateInCartResponse {
  AddressUpdateInCartResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory AddressUpdateInCartResponse.fromJson(Map<String, dynamic> json) => AddressUpdateInCartResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}