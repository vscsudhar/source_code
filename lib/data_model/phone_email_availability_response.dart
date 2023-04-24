// To parse this JSON data, do
//
//     final phoneEmailAvailabilityResponse = phoneEmailAvailabilityResponseFromJson(jsonString);

import 'dart:convert';

PhoneEmailAvailabilityResponse phoneEmailAvailabilityResponseFromJson(String str) => PhoneEmailAvailabilityResponse.fromJson(json.decode(str));

String phoneEmailAvailabilityResponseToJson(PhoneEmailAvailabilityResponse data) => json.encode(data.toJson());

class PhoneEmailAvailabilityResponse {
  PhoneEmailAvailabilityResponse({
    this.phone_available,
    this.email_available,
    this.phone_available_message,
    this.email_available_message,
  });

  bool phone_available;
  bool email_available;
  String phone_available_message;
  String email_available_message;

  factory PhoneEmailAvailabilityResponse.fromJson(Map<String, dynamic> json) => PhoneEmailAvailabilityResponse(
    phone_available: json["phone_available"],
    email_available: json["email_available"],
    phone_available_message: json["phone_available_message"],
    email_available_message: json["email_available_message"],
  );

  Map<String, dynamic> toJson() => {
    "phone_available": phone_available,
    "email_available": email_available,
    "phone_available_message": phone_available_message,
    "email_available_message": email_available_message,
  };
}