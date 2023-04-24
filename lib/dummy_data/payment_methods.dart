class PaymentMethod{
  String id;
  String key;
  String name;
  String image;

  PaymentMethod({this.id,this.key,this.name,this.image});
}

List<PaymentMethod> paymentMethodList = [
  PaymentMethod(id:"1",key:"paypal",name:"Checkout with Paypal",image: "dummy_assets/paypal.png"),
  PaymentMethod(id:"2",key:"stripe",name:"Checkout with Stripe",image: "dummy_assets/stripe.png"),
  PaymentMethod(id:"3",key:"flutterwave",name:"Checkout with Flutterwave",image: "dummy_assets/flutterwave.png"),
  PaymentMethod(id:"4",key:"iyzico",name:"Checkout with IYZICO",image: "dummy_assets/iyzico.png"),
  PaymentMethod(id:"5",key:"mpesa",name:"Checkout with Mpesa",image: "dummy_assets/mpesa.png"),
  PaymentMethod(id:"6",key:"payfast",name:"Checkout with Payfast",image: "dummy_assets/payfast.png"),
  PaymentMethod(id:"7",key:"payhere",name:"Checkout with Payhere",image: "dummy_assets/payhere.png"),
  PaymentMethod(id:"8",key:"paystack",name:"Checkout with Paystack",image: "dummy_assets/ngenius.png"),
  PaymentMethod(id:"9",key:"paytm",name:"Checkout with Paytm",image: "dummy_assets/paytm.jpg"),
  PaymentMethod(id:"10",key:"wallet",name:"Wallet Payment",image: "dummy_assets/wallet.png"),
  PaymentMethod(id:"11",key:"cash_on_delivery",name:"Cash on Delivery",image: "dummy_assets/cod.png"),
];