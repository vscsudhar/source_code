// To parse this JSON data, do
//
//     final profileUpdateResponse = profileUpdateResponseFromJson(jsonString);

import 'dart:convert';

ProfileUpdateResponse profileUpdateResponseFromJson(String str) => ProfileUpdateResponse.fromJson(json.decode(str));

String profileUpdateResponseToJson(ProfileUpdateResponse data) => json.encode(data.toJson());

class ProfileUpdateResponse {
  ProfileUpdateResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) => ProfileUpdateResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}