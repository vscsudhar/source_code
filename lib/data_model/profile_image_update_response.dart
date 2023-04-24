// To parse this JSON data, do
//
//     final profileImageUpdateResponse = profileImageUpdateResponseFromJson(jsonString);

import 'dart:convert';

ProfileImageUpdateResponse profileImageUpdateResponseFromJson(String str) => ProfileImageUpdateResponse.fromJson(json.decode(str));

String profileImageUpdateResponseToJson(ProfileImageUpdateResponse data) => json.encode(data.toJson());

class ProfileImageUpdateResponse {
  ProfileImageUpdateResponse({
    this.result,
    this.message,
    this.path
  });

  bool result;
  String message;
  String path;

  factory ProfileImageUpdateResponse.fromJson(Map<String, dynamic> json) => ProfileImageUpdateResponse(
    result: json["result"],
    message: json["message"],
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "path": path,
  };
}