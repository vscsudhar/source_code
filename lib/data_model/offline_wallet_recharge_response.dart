// To parse this JSON data, do
//
//     final offlineWalletRechargeResponse = offlineWalletRechargeResponseFromJson(jsonString);

import 'dart:convert';

OfflineWalletRechargeResponse offlineWalletRechargeResponseFromJson(String str) => OfflineWalletRechargeResponse.fromJson(json.decode(str));

String offlineWalletRechargeResponseToJson(OfflineWalletRechargeResponse data) => json.encode(data.toJson());

class OfflineWalletRechargeResponse {
  OfflineWalletRechargeResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory OfflineWalletRechargeResponse.fromJson(Map<String, dynamic> json) => OfflineWalletRechargeResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
