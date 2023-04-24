// To parse this JSON data, do
//
//     final languageListResponse = languageListResponseFromJson(jsonString);

import 'dart:convert';

LanguageListResponse languageListResponseFromJson(String str) => LanguageListResponse.fromJson(json.decode(str));

String languageListResponseToJson(LanguageListResponse data) => json.encode(data.toJson());

class LanguageListResponse {
  LanguageListResponse({
    this.languages,
    this.success,
    this.status,
  });

  List<Language> languages;
  bool success;
  int status;

  factory LanguageListResponse.fromJson(Map<String, dynamic> json) => LanguageListResponse(
    languages: List<Language>.from(json["data"].map((x) => Language.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(languages.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Language {
  Language({
    this.id,
    this.name,
    this.image,
    this.code,
    this.mobile_app_code,
    this.rtl,
    this.is_default,
  });

  int id;
  String name;
  String image;
  String code;
  String mobile_app_code;
  bool rtl;
  bool is_default;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    code: json["code"],
    mobile_app_code: json["mobile_app_code"],
    rtl: json["rtl"],
    is_default: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "code": code,
    "mobile_app_code": mobile_app_code,
    "rtl": rtl,
    "is_default": is_default,
  };
}
