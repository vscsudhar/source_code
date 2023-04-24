// To parse this JSON data, do
//
//     final wishListChekResponse = wishListChekResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

WishListChekResponse wishListChekResponseFromJson(String str) => WishListChekResponse.fromJson(json.decode(str));

String wishListChekResponseToJson(WishListChekResponse data) => json.encode(data.toJson());

class WishListChekResponse {
  WishListChekResponse({
    this.message,
    this.is_in_wishlist,
    this.product_id,
    this.wishlist_id,
  });

  String message;
  bool is_in_wishlist;
  int product_id;
  int wishlist_id;

  factory WishListChekResponse.fromJson(Map<String, dynamic> json) => WishListChekResponse(
    message: json["message"],
    is_in_wishlist: json["is_in_wishlist"],
    product_id: json["product_id"],
    wishlist_id: json["wishlist_id"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "is_in_wishlist": is_in_wishlist,
    "product_id": product_id,
    "wishlist_id": wishlist_id,
  };
}