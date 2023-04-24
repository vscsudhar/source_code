// To parse this JSON data, do
//
//     final walletBalanceResponse = walletBalanceResponseFromJson(jsonString);
//https://app.quicktype.io/

import 'dart:convert';

WalletBalanceResponse walletBalanceResponseFromJson(String str) => WalletBalanceResponse.fromJson(json.decode(str));

String walletBalanceResponseToJson(WalletBalanceResponse data) => json.encode(data.toJson());

class WalletBalanceResponse {
  WalletBalanceResponse({
    this.balance,
    this.last_recharged,
  });

  String balance;
  String last_recharged;

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) => WalletBalanceResponse(
    balance: json["balance"],
    last_recharged: json["last_recharged"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "last_recharged": last_recharged,
  };
}