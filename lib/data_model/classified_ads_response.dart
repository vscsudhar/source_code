// To parse this JSON data, do
//
//     final classifiedAdsResponse = classifiedAdsResponseFromJson(jsonString);

import 'dart:convert';

ClassifiedAdsResponse classifiedAdsResponseFromJson(String str) => ClassifiedAdsResponse.fromJson(json.decode(str));

String classifiedAdsResponseToJson(ClassifiedAdsResponse data) => json.encode(data.toJson());

class ClassifiedAdsResponse {
  ClassifiedAdsResponse({
    this.data,
    this.links,
    this.meta,
    this.success,
    this.status,
  });

  List<ClassifiedAdsMiniData> data;
  Links links;
  Meta meta;
  bool success;
  int status;

  factory ClassifiedAdsResponse.fromJson(Map<String, dynamic> json) => ClassifiedAdsResponse(
    data: List<ClassifiedAdsMiniData>.from(json["data"].map((x) => ClassifiedAdsMiniData.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "links": links.toJson(),
    "meta": meta.toJson(),
    "success": success,
    "status": status,
  };
}

class ClassifiedAdsMiniData {
  ClassifiedAdsMiniData({
    this.id,
    this.name,
    this.thumbnailImage,
    this.condition,
    this.published,
    this.status,
    this.category,
    this.unitPrice,
  });

  int id;
  String name;
  String thumbnailImage;
  String condition;
  bool published;
  bool status;

  String category;
  String unitPrice;

  factory ClassifiedAdsMiniData.fromJson(Map<String, dynamic> json) => ClassifiedAdsMiniData(
    id: json["id"],
    name: json["name"],
    thumbnailImage: json["thumbnail_image"],
    condition: json["condition"],
    published: json["published"],
    status: json["status"],
    category: json["category"],
    unitPrice: json["unit_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "thumbnail_image": thumbnailImage,
    "condition": condition,
    "published": published,
    "status": status,
    "category": category,
    "unit_price": unitPrice,
  };
}

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String first;
  String last;
  dynamic prev;
  dynamic next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label,
    "active": active,
  };
}
