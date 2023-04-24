// To parse this JSON data, do
//
//     final cartAddResponse = cartAddResponseFromJson(jsonString);

import 'dart:convert';

CartAddResponse cartAddResponseFromJson(String str) => CartAddResponse.fromJson(json.decode(str));

String cartAddResponseToJson(CartAddResponse data) => json.encode(data.toJson());

class CartAddResponse {
  CartAddResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory CartAddResponse.fromJson(Map<String, dynamic> json) => CartAddResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}