class SingleProduct {
  String image;
  List<String> product_images;
  String name;
  String price;
  String discounted_price;
  bool has_disocunt;
  String price_range;
  double rating;
  int rating_count;
  bool in_user_wishlist;
  double club_point;
  Seller seller;
  bool is_inhouse_product;
  String description;

  SingleProduct(
      {this.image,
      this.product_images,
      this.name,
      this.price,
      this.discounted_price,
      this.has_disocunt,
      this.price_range,
      this.rating,
      this.rating_count,
      this.in_user_wishlist,
      this.club_point,
      this.seller,
      this.is_inhouse_product,this.description});
}

class Seller {
  String shop_name;
  String shop_image;

  Seller({this.shop_name, this.shop_image});
}

Seller seller =
    Seller(shop_name: "UGG Australia", shop_image: "dummy_assets/s8.jpg");

List<String> my_product_images = [
  'dummy_assets/pi1.jpg',
  'dummy_assets/pi2.jpg',
  'dummy_assets/pi3.jpg',
  'dummy_assets/pi4.jpg',
];

String description = """ Brand: Apple
Model: iPhone 11 Pro
Color: Gray (As given picture).

Body
Dimensions: 144 x 71.4 x 8.1 mm (5.67 x 2.81 x 0.32 in)
Weight: 188 g (6.63 oz)
Build: Glass front (Gorilla Glass), glass back (Gorilla Glass), stainless steel frame
SIM: Nano-SIM and/or eSIM
IP68 dust/water resistant (up to 4m for 30 mins)
Apple Pay (Visa, MasterCard, AMEX certified)

Display
Type: Super Retina XDR OLED capacitive touchscreen, 16M colors
Size: 5.8 inches, 84.4 cm2 (~82.1% screen-to-body ratio)
Resolution: 1125 x 2436 pixels, 19.5:9 ratio (~458 ppi density)
Protection: Scratch-resistant glass, oleophobic coating
800 nits max brightness
Dolby Vision
HDR10
Wide color gamut
True-tone
120Hz touch-sensing

Platform
OS: iOS 13, upgradable to iOS 13.3
Chipset: Apple A13 Bionic (7 nm+)
CPU: Hexa-core (2x2.65 GHz Lightning + 4x1.8 GHz Thunder)
GPU: Apple GPU (4-core graphics)

Memory
Card slot: No
Internal: 256GB 4GB RAM

Main Camera
Triple: 12 MP, f/1.8, 26mm (wide), 1/2.55", 1.4µm, dual pixel PDAF, OIS
12 MP, f/2.0, 52mm (telephoto), 1/3.4", 1.0µm, PDAF, OIS, 2x optical zoom
12 MP, f/2.4, 13mm (ultrawide)
Features: Quad-LED dual-tone flash, HDR (photo/panorama)
Video: 2160p@24/30/60fps, 1080p@30/60/120/240fps, HDR, stereo sound rec.

Selfie camera
Dual: 12 MP, f/2.2, 23mm (wide)
SL 3D camera
Features: HDR
Video: 2160p@24/30/60fps, 1080p@30/60/120fps, gyro-EIS

Sound
Loudspeaker: Yes, with stereo speakers
3.5mm jack: No
Dolby Atmos
Dolby Digital Plus

Comms
WLAN: Wi-Fi 802.11 a/b/g/n/ac/ax, dual-band, hotspot
Bluetooth: 5.0, A2DP, LE
GPS: Yes, with A-GPS, GLONASS, GALILEO, QZSS
NFC: Yes
Radio: No
USB: 2.0, proprietary reversible connector

Features
Sensors: Face ID, accelerometer, gyro, proximity, compass, barometer
Siri natural language commands and dictation

Battery:
Non-removable Li-Ion 3046 mAh battery (11.67 Wh)
Charging: Fast battery charging 18W: 50% in 30 min
USB Power Delivery 2.0
Qi wireless charging
Talk time: Up to 18 h (multimedia)
Music play: Up to 65 h

Warranty: 1 Year Brand Warranty""";

SingleProduct singleProduct = SingleProduct(
    product_images: my_product_images,
    name: "iPhone 11, iPhone 11 Pro, iPhone XS, iPhone 8 Plus",
    rating: 3.0,
    rating_count: 123,
    in_user_wishlist: false,
    price: "\$11350.00",
    discounted_price: "\$121350.00",
    has_disocunt: true,
    club_point: 120.00,
    seller: seller,
    is_inhouse_product: true,description: description);
