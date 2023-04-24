// To parse this JSON data, do
//
//     final deviceTokenUpdateResponse = deviceTokenUpdateResponseFromJson(jsonString);

import 'dart:convert';

DeviceTokenUpdateResponse deviceTokenUpdateResponseFromJson(String str) => DeviceTokenUpdateResponse.fromJson(json.decode(str));

String deviceTokenUpdateResponseToJson(DeviceTokenUpdateResponse data) => json.encode(data.toJson());

class DeviceTokenUpdateResponse {
  DeviceTokenUpdateResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory DeviceTokenUpdateResponse.fromJson(Map<String, dynamic> json) => DeviceTokenUpdateResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}