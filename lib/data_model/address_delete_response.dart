// To parse this JSON data, do
//
//     final addressDeleteResponse = addressDeleteResponseFromJson(jsonString);

import 'dart:convert';

AddressDeleteResponse addressDeleteResponseFromJson(String str) => AddressDeleteResponse.fromJson(json.decode(str));

String addressDeleteResponseToJson(AddressDeleteResponse data) => json.encode(data.toJson());

class AddressDeleteResponse {
  AddressDeleteResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory AddressDeleteResponse.fromJson(Map<String, dynamic> json) => AddressDeleteResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}