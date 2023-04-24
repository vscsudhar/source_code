// To parse this JSON data, do
//
//     final carriersResponse = carriersResponseFromJson(jsonString);

import 'dart:convert';

CarriersResponse carriersResponseFromJson(String str) => CarriersResponse.fromJson(json.decode(str));

String carriersResponseToJson(CarriersResponse data) => json.encode(data.toJson());

class CarriersResponse {
  CarriersResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Carrier> data;
  bool success;
  int status;

  factory CarriersResponse.fromJson(Map<String, dynamic> json) => CarriersResponse(
    data: List<Carrier>.from(json["data"].map((x) => Carrier.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Carrier {
  Carrier({
    this.id,
    this.name,
    this.logo,
    this.transitTime,
    this.freeShipping,
    this.transitPrice,
  });

  int id;
  String name;
  String logo;
  var transitTime;
  bool freeShipping;
  var transitPrice;

  factory Carrier.fromJson(Map<String, dynamic> json) => Carrier(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    transitTime: json["transit_time"],
    freeShipping: json["free_shipping"],
    transitPrice: json["transit_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
    "transit_time": transitTime,
    "free_shipping": freeShipping,
    "transit_price": transitPrice,
  };
}
