// To parse this JSON data, do
//
//     final cityResponse = cityResponseFromJson(jsonString);

import 'dart:convert';

CityResponse cityResponseFromJson(String str) => CityResponse.fromJson(json.decode(str));

String cityResponseToJson(CityResponse data) => json.encode(data.toJson());

class CityResponse {
  CityResponse({
    this.cities,
    this.success,
    this.status,
  });

  List<City> cities;
  bool success;
  int status;

  factory CityResponse.fromJson(Map<String, dynamic> json) => CityResponse(
    cities: List<City>.from(json["data"].map((x) => City.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(cities.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class City {
  City({
    this.id,
    this.state_id,
    this.name,
  });

  @override toString() => '$name';

  int id;
  int state_id;
  String name;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    state_id: json["state_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state_id": state_id,
    "name": name,
  };
}
