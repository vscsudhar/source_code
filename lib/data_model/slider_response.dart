// To parse this JSON data, do
//
//     final sliderResponse = sliderResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

SliderResponse sliderResponseFromJson(String str) => SliderResponse.fromJson(json.decode(str));

String sliderResponseToJson(SliderResponse data) => json.encode(data.toJson());

class SliderResponse {
  SliderResponse({
    this.sliders,
    this.success,
    this.status,
  });

  List<Slider> sliders;
  bool success;
  int status;

  factory SliderResponse.fromJson(Map<String, dynamic> json) => SliderResponse(
    sliders: List<Slider>.from(json["data"].map((x) => Slider.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(sliders.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Slider {
  Slider({
    this.photo,
  });

  String photo;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "photo": photo,
  };
}