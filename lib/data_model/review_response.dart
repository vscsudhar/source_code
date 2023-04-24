// To parse this JSON data, do
//
//     final reviewResponse = reviewResponseFromJson(jsonString);

import 'dart:convert';

ReviewResponse reviewResponseFromJson(String str) => ReviewResponse.fromJson(json.decode(str));

String reviewResponseToJson(ReviewResponse data) => json.encode(data.toJson());

class ReviewResponse {
  ReviewResponse({
    this.reviews,
    this.meta,
    this.success,
    this.status,
  });

  List<Review> reviews;
  Meta meta;
  bool success;
  int status;

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
    reviews: List<Review>.from(json["data"].map((x) => Review.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(reviews.map((x) => x.toJson())),
    "meta": meta.toJson(),
    "success": success,
    "status": status,
  };
}

class Review {
  Review({
    this.user_id,
    this.user_name,
    this.avatar,
    this.rating,
    this.comment,
    this.time,
  });

  int user_id;
  String user_name;
  String avatar;
  double rating;
  String comment;
  String time;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    user_id: json["user_id"],
    user_name: json["user_name"],
    avatar: json["avatar"],
    rating: json["rating"].toDouble(),
    comment: json["comment"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": user_id,
    "user_name": user_name,
    "avatar": avatar,
    "rating": rating,
    "comment": comment,
    "time": time,
  };
}


class Meta {
  Meta({
    this.current_page,
    this.from,
    this.last_page,
    this.path,
    this.per_page,
    this.to,
    this.total,
  });

  int current_page;
  int from;
  int last_page;
  String path;
  int per_page;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    current_page: json["current_page"],
    from: json["from"],
    last_page: json["last_page"],
    path: json["path"],
    per_page: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": current_page,
    "from": from,
    "last_page": last_page,
    "path": path,
    "per_page": per_page,
    "to": to,
    "total": total,
  };
}
