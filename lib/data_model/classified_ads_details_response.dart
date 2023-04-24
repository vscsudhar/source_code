// To parse this JSON data, do
//
//     final classifiedAdsDetailsResponse = classifiedAdsDetailsResponseFromJson(jsonString);

import 'dart:convert';

ClassifiedAdsDetailsResponse classifiedAdsDetailsResponseFromJson(String str) => ClassifiedAdsDetailsResponse.fromJson(json.decode(str));

String classifiedAdsDetailsResponseToJson(ClassifiedAdsDetailsResponse data) => json.encode(data.toJson());

class ClassifiedAdsDetailsResponse {
  ClassifiedAdsDetailsResponse({
    this.data,
    this.success,
    this.status,
  });

  List<ClassifiedAdsData> data;
  bool success;
  int status;

  factory ClassifiedAdsDetailsResponse.fromJson(Map<String, dynamic> json) => ClassifiedAdsDetailsResponse(
    data: List<ClassifiedAdsData>.from(json["data"].map((x) => ClassifiedAdsData.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class ClassifiedAdsData {
  ClassifiedAdsData({
    this.id,
    this.name,
    this.phone,
    this.addedBy,
    this.location,
    this.condition,
    this.photos,
    this.thumbnailImage,
    this.tags,
    this.unitPrice,
    this.unit,
    this.description,
    this.videoLink,
    this.category,
    this.brand,
    this.link,
  });

  int id;
  String name;
  String phone;
  String addedBy;
  String location;
  String condition;
  List<Photo> photos;
  String thumbnailImage;
  List<String> tags;
  String unitPrice;
  String unit;
  String description;
  String videoLink;
  String category;
  Brand brand;
  String link;

  factory ClassifiedAdsData.fromJson(Map<String, dynamic> json) => ClassifiedAdsData(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    addedBy: json["added_by"],
    location: json["location"],
    condition: json["condition"],
    photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    thumbnailImage: json["thumbnail_image"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    unitPrice: json["unit_price"],
    unit: json["unit"],
    description: json["description"],
    videoLink: json["video_link"],
    category: json["category"],
    brand: Brand.fromJson(json["brand"]),
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "added_by": addedBy,
    "location": location,
    "condition": condition,
    "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    "thumbnail_image": thumbnailImage,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "unit_price": unitPrice,
    "unit": unit,
    "description": description,
    "video_link": videoLink,
    "category": category,
    "brand": brand.toJson(),
    "link": link,
  };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.logo,
  });

  int id;
  String name;
  String logo;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
  };
}

class Photo {
  Photo({
    this.variant,
    this.path,
  });

  String variant;
  String path;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    variant: json["variant"],
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "variant": variant,
    "path": path,
  };
}
