// To parse this JSON data, do
//
//     final nagadBeginResponse = nagadBeginResponseFromJson(jsonString);

import 'dart:convert';

NagadBeginResponse nagadBeginResponseFromJson(String str) => NagadBeginResponse.fromJson(json.decode(str));

String nagadBeginResponseToJson(NagadBeginResponse data) => json.encode(data.toJson());

class NagadBeginResponse {
  NagadBeginResponse({
    this.token,
    this.result,
    this.url,
    this.message,
  });

  String token;
  bool result;
  String url;
  String message;

  factory NagadBeginResponse.fromJson(Map<String, dynamic> json) => NagadBeginResponse(
    token: json["token"],
    result: json["result"],
    url: json["url"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "result": result,
    "url": url,
    "message": message,
  };
}