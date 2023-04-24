class SingleShop {
  String logo;
  List<String> sliders;
  String name;
  String address;
  double rating;

  SingleShop({
    this.logo,
    this.sliders,
    this.name,
    this.address,
    this.rating,
  });
}

List<String> sliders = [
  'dummy_assets/ss1.jpg',
  'dummy_assets/ss2.jpg',
  'dummy_assets/ss3.jpg',
  'dummy_assets/ss4.jpg',
];

SingleShop singleShop = SingleShop(
  logo: "dummy_assets/s7.jpg",
  sliders: sliders,
  name: "A-Z Imports & Exports International",
  address: "92/A Johnson street, New Arlington, NY Usa",
  rating: 3.0,
);
