// To parse this JSON data, do
//
//     final userInfoResponse = userInfoResponseFromJson(jsonString);

import 'dart:convert';

UserInfoResponse userInfoResponseFromJson(String str) => UserInfoResponse.fromJson(json.decode(str));

String userInfoResponseToJson(UserInfoResponse data) => json.encode(data.toJson());

class UserInfoResponse {
  UserInfoResponse({
    this.data,
    this.success,
    this.status,
  });

  List<UserInformation> data;
  bool success;
  int status;

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) => UserInfoResponse(
    data: List<UserInformation>.from(json["data"].map((x) => UserInformation.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class UserInformation {
  UserInformation({
    this.name,
    this.email,
    this.avatar,
    this.address,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.phone,
    this.balance,
    this.remainingUploads,
    this.packageId,
    this.packageName,
  });

  String name;
  String email;
  String avatar;
  String address;
  String country;
  String state;
  String city;
  String postalCode;
  String phone;
  String balance;
  var remainingUploads;
  int packageId;
  String packageName;

  factory UserInformation.fromJson(Map<String, dynamic> json) => UserInformation(
    name: json["name"],
    email: json["email"],
    avatar: json["avatar"],
    address: json["address"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    postalCode: json["postal_code"],
    phone: json["phone"],
    balance: json["balance"],
    remainingUploads: json["remaining_uploads"],
    packageId: json["package_id"],
    packageName: json["package_name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "avatar": avatar,
    "address": address,
    "country": country,
    "state": state,
    "city": city,
    "postal_code": postalCode,
    "phone": phone,
    "balance": balance,
    "remaining_uploads": remainingUploads,
    "package_id": packageId,
    "package_name": packageName,
  };
}
