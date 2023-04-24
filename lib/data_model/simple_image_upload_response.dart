// To parse this JSON data, do
//
//     final simpleImageUploadResponse = simpleImageUploadResponseFromJson(jsonString);

import 'dart:convert';

SimpleImageUploadResponse simpleImageUploadResponseFromJson(String str) => SimpleImageUploadResponse.fromJson(json.decode(str));

String simpleImageUploadResponseToJson(SimpleImageUploadResponse data) => json.encode(data.toJson());

class SimpleImageUploadResponse {
  SimpleImageUploadResponse({
    this.result,
    this.message,
    this.path,
    this.upload_id,
  });

  bool result;
  String message;
  String path;
  int upload_id;

  factory SimpleImageUploadResponse.fromJson(Map<String, dynamic> json) => SimpleImageUploadResponse(
    result: json["result"],
    message: json["message"],
    path: json["path"],
    upload_id: json["upload_id"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "path": path,
    "upload_id": upload_id,
  };
}