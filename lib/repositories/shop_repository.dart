import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/shop_response.dart';
import 'package:active_ecommerce_flutter/data_model/shop_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class ShopRepository {
  Future<dynamic> getShops({name = "", page = 1}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/shops" + "?page=${page}&name=${name}");

    print(url.toString());

    final response = await http.get(url,
      headers: {
        "App-Language": app_language.$,
      },);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return shopResponseFromJson(response.body);
  }

  Future<ShopDetailsResponse> getShopInfo({@required id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/details/${id}");
    print(url.toString());
    final response =
        await http.get(url,
          headers: {
            "App-Language": app_language.$,
          },);


    return shopDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts({int id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/products/top/" + id.toString());
    final response = await http
        .get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getNewFromThisSellerProducts({int id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/products/new/" + id.toString());
    final response = await http
        .get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getfeaturedFromThisSellerProducts(
      {int id = 0}) async {

    Uri url =  Uri.parse("${AppConfig.BASE_URL}/shops/products/featured/" + id.toString());
    final response = await http
        .get(url,
      headers: {
        "App-Language": app_language.$,
      },);
    return productMiniResponseFromJson(response.body);
  }
}
