// To parse this JSON data, do
//
//     final nagadPaymentProcessResponse = nagadPaymentProcessResponseFromJson(jsonString);

import 'dart:convert';

NagadPaymentProcessResponse nagadPaymentProcessResponseFromJson(String str) => NagadPaymentProcessResponse.fromJson(json.decode(str));

String nagadPaymentProcessResponseToJson(NagadPaymentProcessResponse data) => json.encode(data.toJson());

class NagadPaymentProcessResponse {
  NagadPaymentProcessResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory NagadPaymentProcessResponse.fromJson(Map<String, dynamic> json) => NagadPaymentProcessResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}