// To parse this JSON data, do
//
//     final businessSettingListResponse = businessSettingListResponseFromJson(jsonString);

import 'dart:convert';

List<BusinessSettingListResponse> businessSettingListResponseFromJson(String str) => List<BusinessSettingListResponse>.from(json.decode(str).map((x) => BusinessSettingListResponse.fromJson(x)));

String businessSettingListResponseToJson(List<BusinessSettingListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessSettingListResponse {
  BusinessSettingListResponse({
    this.id,
    this.type,
    this.value,
    this.lang,
  });

  int id;
  String type;
  var value;
  dynamic lang;

  factory BusinessSettingListResponse.fromJson(Map<String, dynamic> json) => BusinessSettingListResponse(
    id: json["id"],
    type: json["type"],
    value: json["value"],
    lang: json["lang"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "value": value,
    "lang": lang,
  };
}