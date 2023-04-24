// To parse this JSON data, do
//
//     final profileCountersResponse = profileCountersResponseFromJson(jsonString);

import 'dart:convert';

ProfileCountersResponse profileCountersResponseFromJson(String str) => ProfileCountersResponse.fromJson(json.decode(str));

String profileCountersResponseToJson(ProfileCountersResponse data) => json.encode(data.toJson());

class ProfileCountersResponse {
  ProfileCountersResponse({
    this.cart_item_count,
    this.wishlist_item_count,
    this.order_count,
  });

  int cart_item_count;
  int wishlist_item_count;
  int order_count;

  factory ProfileCountersResponse.fromJson(Map<String, dynamic> json) => ProfileCountersResponse(
    cart_item_count: json["cart_item_count"],
    wishlist_item_count: json["wishlist_item_count"],
    order_count: json["order_count"],
  );

  Map<String, dynamic> toJson() => {
    "cart_item_count": cart_item_count,
    "wishlist_item_count": wishlist_item_count,
    "order_count": order_count,
  };
}