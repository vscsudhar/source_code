// To parse this JSON data, do
//
//     final CustomerPackageResponse = CustomerPackageResponseFromJson(jsonString);

import 'dart:convert';

CustomerPackageResponse customerPackageResponseFromJson(String str) => CustomerPackageResponse.fromJson(json.decode(str));

String customerPackageResponseToJson(CustomerPackageResponse data) => json.encode(data.toJson());

class CustomerPackageResponse {
  CustomerPackageResponse({
    this.data,
  });

  List<Package> data;

  factory CustomerPackageResponse.fromJson(Map<String, dynamic> json) => CustomerPackageResponse(
    data: List<Package>.from(json["data"].map((x) => Package.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Package {
  Package({
    this.id,
    this.name,
    this.logo,
    this.productUploadLimit,
    this.amount,
    this.price,

  });

  int id;
  String name;
  String logo;
  int productUploadLimit;
  String amount;
  var price;


  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    productUploadLimit: json["product_upload_limit"],
    amount: json["amount"],
    price: json["price"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
    "product_upload_limit": productUploadLimit,
    "amount": amount,
    "price": price,
  };
}
