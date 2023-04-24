class Order {
  String code;
  String date;
  String payment_status;
  String payment_status_string;
  String delivery_status;
  String delivery_status_string;
  String amount;

  Order(
      {this.code,
      this.date,
      this.payment_status,
      this.payment_status_string,
      this.delivery_status,
      this.delivery_status_string,
      this.amount});
}

final List<Order> orderList = [
  Order(
      code: "20201215-12034564",
      date: "15-12-2020",
      payment_status: "paid",
      payment_status_string: "Paid",
      delivery_status: "pending",
      delivery_status_string: "Order Placed",
      amount: "\$8850.00"),
  Order(
      code: "20201215-22366548",
      date: "17-11-2020",
      payment_status: "unpaid",
      payment_status_string: "Unpaid",
      delivery_status: "pending",
      delivery_status_string: "Order Placed",
      amount: "\$250.00"),
  Order(
      code: "20201215-22366548",
      date: "03-05-2020",
      payment_status: "paid",
      payment_status_string: "Paid",
      delivery_status: "on_delivery",
      delivery_status_string: "On Delivery",
      amount: "\$33654410.00"),

  Order(
      code: "20201215-12034564",
      date: "15-12-2020",
      payment_status: "paid",
      payment_status_string: "Paid",
      delivery_status: "pending",
      delivery_status_string: "Order Placed",
      amount: "\$8850.00"),
  Order(
      code: "20201215-22366548",
      date: "17-11-2020",
      payment_status: "unpaid",
      payment_status_string: "Unpaid",
      delivery_status: "pending",
      delivery_status_string: "Order Placed",
      amount: "\$250.00"),
  Order(
      code: "20201215-22366548",
      date: "03-05-2020",
      payment_status: "paid",
      payment_status_string: "Paid",
      delivery_status: "on_delivery",
      delivery_status_string: "On Delivery",
      amount: "\$33654410.00"),

  Order(
      code: "20201215-12034564",
      date: "15-12-2020",
      payment_status: "paid",
      payment_status_string: "Paid",
      delivery_status: "pending",
      delivery_status_string: "Order Placed",
      amount: "\$8850.00"),
  Order(
      code: "20201215-22366548",
      date: "17-11-2020",
      payment_status: "unpaid",
      payment_status_string: "Unpaid",
      delivery_status: "pending",
      delivery_status_string: "Order Placed",
      amount: "\$250.00"),
  Order(
      code: "20201215-22366548",
      date: "03-05-2020",
      payment_status: "paid",
      payment_status_string: "Paid",
      delivery_status: "on_delivery",
      delivery_status_string: "On Delivery",
      amount: "\$33654410.00"),
];
