// To parse this JSON data, do
//
//     final orderItemlResponse = orderItemlResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

OrderItemResponse orderItemlResponseFromJson(String str) => OrderItemResponse.fromJson(json.decode(str));

String orderItemlResponseToJson(OrderItemResponse data) => json.encode(data.toJson());

class OrderItemResponse {
  OrderItemResponse({
    this.ordered_items,
    this.success,
    this.status,
  });

  List<OrderItem> ordered_items;
  bool success;
  int status;

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) => OrderItemResponse(
    ordered_items: List<OrderItem>.from(json["data"].map((x) => OrderItem.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(ordered_items.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class OrderItem {
  OrderItem({
    this.id,
    this.product_id,
    this.product_name,
    this.variation,
    this.price,
    this.tax,
    this.shipping_cost,
    this.coupon_discount,
    this.quantity,
    this.payment_status,
    this.payment_status_string,
    this.delivery_status,
    this.delivery_status_string,
    this.refund_section,
    this.refund_button,
    this.refund_label,
    this.refund_request_status
  });

  int id;
  int product_id;
  String product_name;
  String variation;
  String price;
  String tax;
  String shipping_cost;
  String coupon_discount;
  int quantity;
  String payment_status;
  String payment_status_string;
  String delivery_status;
  String delivery_status_string;
  bool refund_section;
  bool refund_button;
  String refund_label;
  int refund_request_status;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    product_id: json["product_id"],
    product_name: json["product_name"],
    variation: json["variation"],
    price: json["price"],
    tax: json["tax"],
    shipping_cost: json["shipping_cost"],
    coupon_discount: json["coupon_discount"],
    quantity: json["quantity"],
    payment_status: json["payment_status"],
    payment_status_string: json["payment_status_string"],
    delivery_status: json["delivery_status"],
    delivery_status_string: json["delivery_status_string"],
    refund_section: json["refund_section"],
    refund_button: json["refund_button"],
    refund_label: json["refund_label"],
    refund_request_status: json["refund_request_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": product_id,
    "product_name": product_name,
    "variation": variation,
    "price": price,
    "tax": tax,
    "shipping_cost": shipping_cost,
    "coupon_discount": coupon_discount,
    "quantity": quantity,
    "payment_status": payment_status,
    "payment_status_string": payment_status_string,
    "delivery_status": delivery_status,
    "delivery_status_string": delivery_status_string,
    "refund_section": refund_section,
    "refund_button": refund_button,
    "refund_label": refund_label,
    "refund_request_status": refund_request_status,
  };
}
