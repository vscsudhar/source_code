// To parse this JSON data, do
//
//     final flashDealResponse = flashDealResponseFromJson(jsonString);

import 'dart:convert';

FlashDealResponse flashDealResponseFromJson(String str) => FlashDealResponse.fromJson(json.decode(str));

String flashDealResponseToJson(FlashDealResponse data) => json.encode(data.toJson());

class FlashDealResponse {
  FlashDealResponse({
    this.flashDeals,
    this.success,
    this.status,
  });

  List<FlashDealResponseDatum> flashDeals;
  bool success;
  int status;

  factory FlashDealResponse.fromJson(Map<String, dynamic> json) => FlashDealResponse(
    flashDeals: List<FlashDealResponseDatum>.from(json["data"].map((x) => FlashDealResponseDatum.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(flashDeals.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class FlashDealResponseDatum {
  FlashDealResponseDatum({
    this.id,
    this.title,
    this.date,
    this.banner,
    this.products,
  });

  int id;
  String title;
  int date;
  String banner;
  Products products;

  factory FlashDealResponseDatum.fromJson(Map<String, dynamic> json) => FlashDealResponseDatum(
    id: json["id"],
    title: json["title"],
    date: json["date"],
    banner: json["banner"],
    products: Products.fromJson(json["products"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "date": date,
    "banner": banner,
    "products": products.toJson(),
  };
}

class Products {
  Products({
    this.products,
  });

  List<Product> products;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    products: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  Product({
    this.id,
    this.name,
    this.price,
    this.image,
    this.links,
  });

  var id;
  String name;
  String price;
  String image;
  Links links;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    image: json["image"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "image": image,
    "links": links.toJson(),
  };
}

class Links {
  Links({
    this.details,
  });

  String details;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    details: json["details"],
  );

  Map<String, dynamic> toJson() => {
    "details": details,
  };
}
