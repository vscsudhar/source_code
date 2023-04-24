import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/slider_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
class SlidersRepository {
  Future<SliderResponse> getSliders() async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/sliders");
    final response =
        await http.get(url,
          headers: {
            "App-Language": app_language.$,
          },);
    /*print(response.body.toString());
    print("sliders");*/
    return sliderResponseFromJson(response.body);
  }

  Future<SliderResponse> getBannerOneImages() async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/banners-one");
    final response =
    await http.get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    /*print(response.body.toString());
    print("sliders");*/
    return sliderResponseFromJson(response.body);
  }

  Future<SliderResponse> getBannerTwoImages() async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/banners-two");
    final response =
    await http.get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    /*print(response.body.toString());
    print("sliders");*/
    return sliderResponseFromJson(response.body);
  }

  Future<SliderResponse> getBannerThreeImages() async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/banners-three");
    final response =
    await http.get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    /*print(response.body.toString());
    print("sliders");*/
    return sliderResponseFromJson(response.body);
  }
}
