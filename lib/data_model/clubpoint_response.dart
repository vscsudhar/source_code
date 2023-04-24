// To parse this JSON data, do
//
//     final clubpointResponse = clubpointResponseFromJson(jsonString);

import 'dart:convert';

ClubpointResponse clubpointResponseFromJson(String str) => ClubpointResponse.fromJson(json.decode(str));

String clubpointResponseToJson(ClubpointResponse data) => json.encode(data.toJson());

class ClubpointResponse {
  ClubpointResponse({
    this.clubpoints,
    this.links,
    this.meta,
    this.success,
    this.status,
  });

  List<ClubPoint> clubpoints;
  Links links;
  Meta meta;
  bool success;
  int status;

  factory ClubpointResponse.fromJson(Map<String, dynamic> json) => ClubpointResponse(
    clubpoints: List<ClubPoint>.from(json["data"].map((x) => ClubPoint.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(clubpoints.map((x) => x.toJson())),
    "links": links.toJson(),
    "meta": meta.toJson(),
    "success": success,
    "status": status,
  };
}

class ClubPoint {
  ClubPoint({
    this.id,
    this.user_id,
    this.orderCode,
    this.points,
    this.convertible_club_point,
    this.convert_status,
    this.date,
  });

  int id;
  int user_id;
  var orderCode;
  double points;
  var convertible_club_point;
  int convert_status;
  String date;

  factory ClubPoint.fromJson(Map<String, dynamic> json) => ClubPoint(
    id: json["id"],
    user_id: json["user_id"],
    orderCode: json["order_code"],
    points: json["points"].toDouble(),
    convertible_club_point: json["convertible_club_point"],
    convert_status: json["convert_status"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": user_id,
    "order_code": orderCode,
    "points": points,
    "convertible_club_point": convertible_club_point,
    "convert_status": convert_status,
    "date": date,
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
  String next;

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
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}
