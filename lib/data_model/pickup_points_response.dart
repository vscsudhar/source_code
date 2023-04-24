// To parse this JSON data, do
//
//     final pickupPointListResponse = pickupPointListResponseFromJson(jsonString);

import 'dart:convert';

PickupPointListResponse pickupPointListResponseFromJson(String str) => PickupPointListResponse.fromJson(json.decode(str));

String pickupPointListResponseToJson(PickupPointListResponse data) => json.encode(data.toJson());

class PickupPointListResponse {
  PickupPointListResponse({
    this.data,
  });

  List<PickupPoint> data;

  factory PickupPointListResponse.fromJson(Map<String, dynamic> json) => PickupPointListResponse(
    data: List<PickupPoint>.from(json["data"].map((x) => PickupPoint.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PickupPoint {
  PickupPoint({
    this.id,
    this.staffId,
    this.name,
    this.address,
    this.phone,
    this.pickUpStatus,
    this.cashOnPickupStatus,
  });

  int id;
  int staffId;
  String name;
  String address;
  String phone;
  int pickUpStatus;
  dynamic cashOnPickupStatus;

  factory PickupPoint.fromJson(Map<String, dynamic> json) => PickupPoint(
    id: json["id"],
    staffId: json["staff_id"],
    name: json["name"],
    address: json["address"],
    phone: json["phone"],
    pickUpStatus: json["pick_up_status"],
    cashOnPickupStatus: json["cash_on_pickup_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "staff_id": staffId,
    "name": name,
    "address": address,
    "phone": phone,
    "pick_up_status": pickUpStatus,
    "cash_on_pickup_status": cashOnPickupStatus,
  };
}
