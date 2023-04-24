// To parse this JSON data, do
//
//     final walletRechargeResponse = walletRechargeResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

WalletRechargeResponse walletRechargeResponseFromJson(String str) => WalletRechargeResponse.fromJson(json.decode(str));

String walletRechargeResponseToJson(WalletRechargeResponse data) => json.encode(data.toJson());

class WalletRechargeResponse {
  WalletRechargeResponse({
    this.recharges,
    this.links,
    this.meta,
    this.result,
    this.status,
  });

  List<Recharge> recharges;
  Links links;
  Meta meta;
  bool result;
  int status;

  factory WalletRechargeResponse.fromJson(Map<String, dynamic> json) => WalletRechargeResponse(
    recharges: List<Recharge>.from(json["data"].map((x) => Recharge.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
    result: json["result"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(recharges.map((x) => x.toJson())),
    "links": links.toJson(),
    "meta": meta.toJson(),
    "result": result,
    "status": status,
  };
}

class Recharge {
  Recharge({
    this.amount,
    this.payment_method,
    this.approval_string,
    this.date,
  });

  String amount;
  String payment_method;
  String approval_string;
  String date;

  factory Recharge.fromJson(Map<String, dynamic> json) => Recharge(
    amount: json["amount"],
    payment_method: json["payment_method"],
    approval_string: json["approval_string"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "payment_method": payment_method,
    "approval_string": approval_string,
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
