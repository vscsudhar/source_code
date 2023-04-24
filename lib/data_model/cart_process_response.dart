// To parse this JSON data, do
//
//     final cartProcessResponse = cartProcessResponseFromJson(jsonString);

import 'dart:convert';

CartProcessResponse cartProcessResponseFromJson(String str) => CartProcessResponse.fromJson(json.decode(str));

String cartProcessResponseToJson(CartProcessResponse data) => json.encode(data.toJson());

class CartProcessResponse {
  CartProcessResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory CartProcessResponse.fromJson(Map<String, dynamic> json) => CartProcessResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}