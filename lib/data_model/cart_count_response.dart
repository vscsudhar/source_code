// To parse this JSON data, do
//
//     final cartCountResponse = cartCountResponseFromJson(jsonString);

import 'dart:convert';

CartCountResponse cartCountResponseFromJson(String str) => CartCountResponse.fromJson(json.decode(str));

String cartCountResponseToJson(CartCountResponse data) => json.encode(data.toJson());

class CartCountResponse {
  CartCountResponse({
    this.count,
    this.status,
  });

  int count;
  bool status;

  factory CartCountResponse.fromJson(Map<String, dynamic> json) => CartCountResponse(
    count: json["count"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "status": status,
  };
}
