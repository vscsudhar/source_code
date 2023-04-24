// To parse this JSON data, do
//
//     final variantResponse = variantResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

VariantResponse variantResponseFromJson(String str) => VariantResponse.fromJson(json.decode(str));

String variantResponseToJson(VariantResponse data) => json.encode(data.toJson());

class VariantResponse {
  VariantResponse({
    this.product_id,
    this.variant,
    this.price,
    this.price_string,
    this.stock,
    this.image,
  });

  int product_id;
  String variant;
  double price;
  String price_string;
  int stock;
  String image;

  factory VariantResponse.fromJson(Map<String, dynamic> json) => VariantResponse(
    product_id: json["product_id"],
    variant: json["variant"],
    price: json["price"].toDouble(),
    price_string: json["price_string"],
    stock: json["stock"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": product_id,
    "variant": variant,
    "price": price,
    "price_string": price_string,
    "stock": stock,
    "image": image,
  };
}