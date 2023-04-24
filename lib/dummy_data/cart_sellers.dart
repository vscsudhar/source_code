class CartSeller {
  String id;
  String name;
  List<CartSellerItem> cartSellerItemList;

  CartSeller({this.id, this.name, this.cartSellerItemList});
}

class CartSellerItem {
  String id;
  String cart_item_id;
  String name;
  String image;
  double price;
  int quantity;
  String currency_symbol;


  CartSellerItem(
      {this.id, this.cart_item_id, this.name, this.image, this.price,this.quantity,this.currency_symbol="\$"});
}

List<CartSellerItem> cartSellerItemsList_1 = [
  CartSellerItem(
    id: "1",
    cart_item_id: "101",
    name: "HP Spectre x360 13-AE517TU 8th Gen Intel Core i7 8550U",
    price: 548.00,
    quantity:2,
    image: "dummy_assets/p1.jpeg",
  ),
  CartSellerItem(
    id: "2",
    cart_item_id: "102",
    name: "Makeup Cosmetic Puff Smooth Beauty Foundation",
    price: 15.00,
    quantity:1,
    image: "dummy_assets/p2.jpeg",
  ),
  CartSellerItem(
    id: "3",
    cart_item_id: "103",
    name:
        "Apple Macbook Air (2017) Dual Core Intel Core i5 (1.8-2.9GHz, 8GB 1600MHz LPDDR3, 256GB PCIe Onboard SSD)",
    price: 1200.00,
    quantity:4,
    image: "dummy_assets/p3.jpeg",
  ),
  CartSellerItem(
    id: "4",
    cart_item_id: "104",
    name: "Chelsea Crew Black Label Ollie Tan Leather High Heel",
    price: 7.00,
    quantity:10,
    image: "dummy_assets/p4.jpeg",
  ),
];

List<CartSellerItem> cartSellerItemsList_2 = [
  CartSellerItem(
    id: "5",
    cart_item_id: "105",
    name:
        "Women Lady Leather Handbag Shoulder Satchel Ladies Bag Evening Tote Purse Hot",
    price: 200.00,
    quantity:1,
    image: "dummy_assets/p5.jpeg",
  ),
  CartSellerItem(
    id: "6",
    cart_item_id: "106",
    name: "New football shoes for Football Boots Nike Phantom ",
    price: 340.00,
    quantity:3,
    image: "dummy_assets/p6.jpeg",
  ),
];

List<CartSellerItem> cartSellerItemsList_3 = [
  CartSellerItem(
    id: "7",
    cart_item_id: "107",
    name:
        "LUENX Aviator Sunglasses for Men Women Polarized - UV 400 Protection with case 60MM",
    price: 45.00,
    quantity: 5,
    image: "dummy_assets/p7.jpeg",
  ),
];

List<CartSeller> cartSellerList = [
  CartSeller(
      id: "1",
      name: "A-Z Importers International",
      cartSellerItemList: cartSellerItemsList_3),
  CartSeller(
      id: "2", name: "Assets Store", cartSellerItemList: cartSellerItemsList_2),
  CartSeller(
      id: "3",
      name: "Nike Sports and goods",
      cartSellerItemList: cartSellerItemsList_1),
];
