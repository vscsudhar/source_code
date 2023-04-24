// To parse this JSON data, do
//
//     final cartResponse = cartResponseFromJson(jsonString);

import 'dart:convert';

List<CartResponse> cartResponseFromJson(String str) => List<CartResponse>.from(json.decode(str).map((x) => CartResponse.fromJson(x)));

String cartResponseToJson(List<CartResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartResponse {
  CartResponse({
    this.name,
    this.owner_id,
    this.cart_items,
  });

  String name;
  int owner_id;
  List<CartItem> cart_items;

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
    name: json["name"] == null ? null : json["name"],
    owner_id: json["owner_id"] == null ? null : json["owner_id"],
    cart_items: json["cart_items"] == null ? null : List<CartItem>.from(json["cart_items"].map((x) => CartItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "owner_id": owner_id == null ? null : owner_id,
    "cart_items": cart_items == null ? null : List<dynamic>.from(cart_items.map((x) => x.toJson())),
  };
}

class CartItem {
  CartItem({
    this.id,
    this.owner_id,
    this.user_id,
    this.product_id,
    this.product_name,
    this.product_thumbnail_image,
    this.variation,
    this.currency_symbol,
    this.price,
    this.tax,
    this.shipping_cost,
    this.quantity,
    this.lower_limit,
    this.upper_limit,
  });

  int id;
  int owner_id;
  int user_id;
  int product_id;
  String product_name;
  String product_thumbnail_image;
  String variation;
  double price;
  String currency_symbol;
  double tax;
  double shipping_cost;
  int quantity;
  int lower_limit;
  int upper_limit;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"] == null ? null : json["id"],
    owner_id: json["owner_id"] == null ? null : json["owner_id"],
    user_id: json["user_id"] == null ? null : json["user_id"],
    product_id: json["product_id"] == null ? null : json["product_id"],
    product_name: json["product_name"] == null ? null : json["product_name"],
    product_thumbnail_image: json["product_thumbnail_image"] == null ? null : json["product_thumbnail_image"],
    variation: json["variation"] == null ? null : json["variation"],
    price: json["price"] == null ? null : json["price"].toDouble(),
    currency_symbol: json["currency_symbol"] == null ? null : json["currency_symbol"],
    tax: json["tax"] == null ? null : json["tax"].toDouble(),
    shipping_cost: json["shipping_cost"] == null ? null : json["shipping_cost"].toDouble(),
    quantity: json["quantity"] == null ? null : json["quantity"],
    lower_limit: json["lower_limit"] == null ? null : json["lower_limit"],
    upper_limit: json["upper_limit"] == null ? null : json["upper_limit"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "owner_id": owner_id == null ? null : owner_id,
    "user_id": user_id == null ? null : user_id,
    "product_id": product_id == null ? null : product_id,
    "product_name": product_name == null ? null : product_name,
    "product_thumbnail_image": product_thumbnail_image == null ? null : product_thumbnail_image,
    "variation": variation == null ? null : variation,
    "price": price == null ? null : price,
    "currency_symbol": currency_symbol == null ? null : currency_symbol,
    "tax": tax == null ? null : tax,
    "shipping_cost": shipping_cost == null ? null : shipping_cost,
    "quantity": quantity == null ? null : quantity,
    "lower_limit": lower_limit == null ? null : lower_limit,
    "upper_limit": upper_limit == null ? null : upper_limit,
  };
}
