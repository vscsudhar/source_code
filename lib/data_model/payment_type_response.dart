// To parse this JSON data, do
//
//     final paymentTypeResponse = paymentTypeResponseFromJson(jsonString);

import 'dart:convert';

List<PaymentTypeResponse> paymentTypeResponseFromJson(String str) => List<PaymentTypeResponse>.from(json.decode(str).map((x) => PaymentTypeResponse.fromJson(x)));

String paymentTypeResponseToJson(List<PaymentTypeResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentTypeResponse {
  PaymentTypeResponse({
    this.payment_type,
    this.payment_type_key,
    this.image,
    this.name,
    this.title,
    this.offline_payment_id,
    this.details
  });

  String payment_type;
  String payment_type_key;
  String image;
  String name;
  String title;
  int offline_payment_id;
  String details;

  factory PaymentTypeResponse.fromJson(Map<String, dynamic> json) => PaymentTypeResponse(
    payment_type: json["payment_type"],
    payment_type_key: json["payment_type_key"],
    image: json["image"],
    name: json["name"],
    title: json["title"],
    offline_payment_id: json["offline_payment_id"],
    details: json["details"],

  );

  Map<String, dynamic> toJson() => {
    "payment_type": payment_type,
    "payment_type_key": payment_type_key,
    "image": image,
    "name": name,
    "title": title,
    "offline_payment_id": offline_payment_id,
    "details": details,
  };
}