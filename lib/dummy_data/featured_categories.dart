class FeaturedCategory {
  String id;
  String image;
  String name;
  bool has_children;

  FeaturedCategory({this.id,this.image, this.name,this.has_children});
}

final List<FeaturedCategory> featuredCategoryList = [
  FeaturedCategory(id:"1",
      image: "dummy_assets/fc1.jpeg", name: "Men Clothing & Fashion",has_children: true),
  FeaturedCategory(id:"2",
      image: "dummy_assets/fc2.jpeg", name: "Computer & Accessories",has_children: true),
  FeaturedCategory(id:"3",
      image: "dummy_assets/fc3.jpeg", name: "Automobile & Motorcycle",has_children: false),
  FeaturedCategory(id:"4",
      image: "dummy_assets/fc4.jpeg", name: "Kids & toy",has_children: true),
  FeaturedCategory(id:"5",
      image: "dummy_assets/fc5.jpeg", name: "Sports & outdoor",has_children: true),
  FeaturedCategory(id:"6",
      image: "dummy_assets/fc6.jpeg", name: "Cellphones & Tabs",has_children: true),
  FeaturedCategory(id:"7",
      image: "dummy_assets/fc7.jpeg", name: "Beauty, Health & Hair",has_children: true),
  FeaturedCategory(id:"8",
      image: "dummy_assets/fc8.jpeg", name: "Home Improvement & Tools",has_children: false),
  FeaturedCategory(id:"9",
      image: "dummy_assets/fc9.jpeg", name: "Home decoration & Appliance",has_children: true),
  FeaturedCategory(id:"10",
      image: "dummy_assets/fc10.jpg", name: "Farming Equipments and Tractors",has_children: true),
];