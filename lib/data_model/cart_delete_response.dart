// To parse this JSON data, do
//
//     final cartDeleteResponse = cartDeleteResponseFromJson(jsonString);

import 'dart:convert';

CartDeleteResponse cartDeleteResponseFromJson(String str) => CartDeleteResponse.fromJson(json.decode(str));

String cartDeleteResponseToJson(CartDeleteResponse data) => json.encode(data.toJson());

class CartDeleteResponse {
  CartDeleteResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory CartDeleteResponse.fromJson(Map<String, dynamic> json) => CartDeleteResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}