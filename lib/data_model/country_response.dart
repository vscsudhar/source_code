// To parse this JSON data, do
//
//     final countryResponse = countryResponseFromJson(jsonString);

import 'dart:convert';

CountryResponse countryResponseFromJson(String str) => CountryResponse.fromJson(json.decode(str));

String countryResponseToJson(CountryResponse data) => json.encode(data.toJson());

class CountryResponse {
  CountryResponse({
    this.countries,
    this.success,
    this.status,
  });

  List<Country> countries;
  bool success;
  int status;

  factory CountryResponse.fromJson(Map<String, dynamic> json) => CountryResponse(
    countries: List<Country>.from(json["data"].map((x) => Country.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(countries.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Country {
  Country({
    this.id,
    this.code,
    this.name,
    this.status,
  });

  @override toString() => '$name';

  int id;
  String code;
  String name;
  int status;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "status": status,
  };
}
