// To parse this JSON data, do
//
//     final shippingCostResponse = shippingCostResponseFromJson(jsonString);

import 'dart:convert';

ShippingCostResponse shippingCostResponseFromJson(String str) => ShippingCostResponse.fromJson(json.decode(str));

String shippingCostResponseToJson(ShippingCostResponse data) => json.encode(data.toJson());

class ShippingCostResponse {
  ShippingCostResponse({
    this.result,
    this.shipping_type,
    this.value,
    this.value_string,
  });

  bool result;
  String shipping_type;
  double value;
  String value_string;

  factory ShippingCostResponse.fromJson(Map<String, dynamic> json) => ShippingCostResponse(
    result: json["result"],
    shipping_type: json["shipping_type"],
    value: double.parse(json["value"].toString()),
    value_string: json["value_string"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "shipping_type": shipping_type,
    "value": value,
    "value_string": value_string,
  };
}