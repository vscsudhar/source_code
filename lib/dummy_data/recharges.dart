class Recharge {
  String date;
  String amount;
  String payment_method;
  String approval;

  Recharge(
      {this.date = "15-12-2020",
      this.amount,
      this.payment_method,
      this.approval = "N/A"});
}

final List<Recharge> rechargeList = [
  Recharge(amount: "\$125400.22", payment_method: "Refund"),
  Recharge(amount: "\$125400.22", payment_method: "Stripe"),
  Recharge(amount: "\$0.22", payment_method: "Paypal"),
  Recharge(amount: "\$125400.00", payment_method: "Refund",approval: "Approved"),

  Recharge(amount: "\$125400.22", payment_method: "Refund"),
  Recharge(amount: "\$125400.22", payment_method: "Stripe"),
  Recharge(amount: "\$0.22", payment_method: "Paypal"),
  Recharge(amount: "\$125400.00", payment_method: "Refund",approval: "Approved"),

  Recharge(amount: "\$125400.22", payment_method: "Refund"),
  Recharge(amount: "\$125400.22", payment_method: "Stripe"),
  Recharge(amount: "\$0.22", payment_method: "Paypal"),
  Recharge(amount: "\$125400.00", payment_method: "Refund",approval: "Approved"),
];
