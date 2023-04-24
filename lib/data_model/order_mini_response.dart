// To parse this JSON data, do
//
//     final orderMiniResponse = orderMiniResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

OrderMiniResponse orderMiniResponseFromJson(String str) => OrderMiniResponse.fromJson(json.decode(str));

String orderMiniResponseToJson(OrderMiniResponse data) => json.encode(data.toJson());

class OrderMiniResponse {
  OrderMiniResponse({
    this.orders,
    this.links,
    this.meta,
    this.success,
    this.status,
  });

  List<Order> orders;
  OrderMiniResponseLinks links;
  Meta meta;
  bool success;
  int status;

  factory OrderMiniResponse.fromJson(Map<String, dynamic> json) => OrderMiniResponse(
    orders: List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
    links: OrderMiniResponseLinks.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(orders.map((x) => x.toJson())),
    "links": links.toJson(),
    "meta": meta == null ? null : meta.toJson(),
    "success": success,
    "status": status,
  };
}

class Order {
  Order({
    this.id,
    this.code,
    this.user_id,
    this.payment_type,
    this.payment_status,
    this.payment_status_string,
    this.delivery_status,
    this.delivery_status_string,
    this.grand_total,
    this.date,
    this.links,
  });

  int id;
  String code;
  int user_id;
  String  payment_type;
  String payment_status;
  String  payment_status_string;
  String delivery_status;
  String delivery_status_string;
  String grand_total;
  String date;
  OrderLinks links;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    code: json["code"],
    user_id: json["user_id"],
    payment_type: json["payment_type"],
    payment_status: json["payment_status"],
    payment_status_string: json["payment_status_string"],
    delivery_status: json["delivery_status"],
    delivery_status_string: json["delivery_status_string"],
    grand_total: json["grand_total"],
    date: json["date"],
    links: OrderLinks.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "user_id": user_id,
    "payment_type":payment_type,
    "payment_status": payment_status,
    "payment_status_string": payment_status_string,
    "delivery_status": delivery_status,
    "delivery_status_string": delivery_status_string,
    "grand_total": grand_total,
    "date": date,
    "links": links.toJson(),
  };
}

class OrderLinks {
  OrderLinks({
    this.details,
  });

  String details;

  factory OrderLinks.fromJson(Map<String, dynamic> json) => OrderLinks(
    details: json["details"],
  );

  Map<String, dynamic> toJson() => {
    "details": details,
  };
}



class OrderMiniResponseLinks {
  OrderMiniResponseLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  dynamic first;
  dynamic last;
  dynamic prev;
  dynamic next;

  factory OrderMiniResponseLinks.fromJson(Map<String, dynamic> json) => OrderMiniResponseLinks(
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

