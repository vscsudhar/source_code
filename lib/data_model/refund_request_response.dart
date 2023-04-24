// To parse this JSON data, do
//
//     final refundRequestResponse = refundRequestResponseFromJson(jsonString);

import 'dart:convert';

RefundRequestResponse refundRequestResponseFromJson(String str) => RefundRequestResponse.fromJson(json.decode(str));

String refundRequestResponseToJson(RefundRequestResponse data) => json.encode(data.toJson());

class RefundRequestResponse {
  RefundRequestResponse({
    this.refund_requests,
    this.links,
    this.meta,
    this.success,
    this.status,
  });

  List<RefundRequest> refund_requests;
  Links links;
  Meta meta;
  bool success;
  int status;

  factory RefundRequestResponse.fromJson(Map<String, dynamic> json) => RefundRequestResponse(
    refund_requests: List<RefundRequest>.from(json["data"].map((x) => RefundRequest.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(refund_requests.map((x) => x.toJson())),
    "links": links.toJson(),
    "meta": meta.toJson(),
    "success": success,
    "status": status,
  };
}

class RefundRequest {
  RefundRequest({
    this.id,
    this.user_id,
    this.order_code,
    this.product_name,
    this.product_price,
    this.refund_status,
    this.refund_label,
    this.date,
  });

  int id;
  int user_id;
  String order_code;
  String product_name;
  String product_price;
  int refund_status;
  String refund_label;
  String date;

  factory RefundRequest.fromJson(Map<String, dynamic> json) => RefundRequest(
    id: json["id"],
    user_id: json["user_id"],
    order_code: json["order_code"],
    product_name: json["product_name"],
    product_price: json["product_price"],
    refund_status: json["refund_status"],
    refund_label: json["refund_label"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": user_id,
    "order_code": order_code,
    "product_name": product_name,
    "product_price": product_price,
    "refund_status": refund_status,
    "refund_label": refund_label,
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
