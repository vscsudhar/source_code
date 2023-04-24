// To parse this JSON data, do
//
//     final addressUpdateResponse = addressUpdateResponseFromJson(jsonString);

import 'dart:convert';

AddressUpdateResponse addressUpdateResponseFromJson(String str) => AddressUpdateResponse.fromJson(json.decode(str));

String addressUpdateResponseToJson(AddressUpdateResponse data) => json.encode(data.toJson());

class AddressUpdateResponse {
  AddressUpdateResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory AddressUpdateResponse.fromJson(Map<String, dynamic> json) => AddressUpdateResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}