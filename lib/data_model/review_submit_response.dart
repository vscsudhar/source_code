// To parse this JSON data, do
//
//     final reviewSubmitResponse = reviewSubmitResponseFromJson(jsonString);

import 'dart:convert';

ReviewSubmitResponse reviewSubmitResponseFromJson(String str) => ReviewSubmitResponse.fromJson(json.decode(str));

String reviewSubmitResponseToJson(ReviewSubmitResponse data) => json.encode(data.toJson());

class ReviewSubmitResponse {
  ReviewSubmitResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory ReviewSubmitResponse.fromJson(Map<String, dynamic> json) => ReviewSubmitResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}