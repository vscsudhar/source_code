// To parse this JSON data, do
//
//     final clubpointToWalletResponse = clubpointToWalletResponseFromJson(jsonString);

import 'dart:convert';

ClubpointToWalletResponse clubpointToWalletResponseFromJson(String str) => ClubpointToWalletResponse.fromJson(json.decode(str));

String clubpointToWalletResponseToJson(ClubpointToWalletResponse data) => json.encode(data.toJson());

class ClubpointToWalletResponse {
  ClubpointToWalletResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory ClubpointToWalletResponse.fromJson(Map<String, dynamic> json) => ClubpointToWalletResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}