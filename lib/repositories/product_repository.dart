import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/classified_ads_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/classified_ads_response.dart';
import 'package:active_ecommerce_flutter/data_model/common_response.dart';
import 'package:active_ecommerce_flutter/data_model/purchased_ditital_product_response.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/variant_response.dart';
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class ProductRepository {
  Future<ProductMiniResponse> getFeaturedProducts({page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/featured?page=${page}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBestSellingProducts() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/best-seller");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTodaysDealProducts() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/todays-deal");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts(
      {@required int id = 0}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/flash-deal-products/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {@required int id = 0, name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/category/" +
        id.toString() +
        "?page=${page}&name=${name}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProducts(
      {@required int id = 0, name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/seller/" +
        id.toString() +
        "?page=${page}&name=${name}");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {@required int id = 0, name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/brand/" +
        id.toString() +
        "?page=${page}&name=${name}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts(
      {name = "",
      sort_key = "",
      page = 1,
      brands = "",
      categories = "",
      min = "",
      max = ""}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/search" +
        "?page=${page}&name=${name}&sort_key=${sort_key}&brands=${brands}&categories=${categories}&min=${min}&max=${max}");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

    Future<ProductMiniResponse> getDigitalProducts(
      {
      page = 1,
      }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/digital?page=$page");
    print(url.toString());

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return productMiniResponseFromJson(response.body);
  }



    Future<ClassifiedAdsResponse> getClassifiedProducts(
      {
      page = 1,
      }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/classified/all?page=$page");
    print(url.toString());

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return classifiedAdsResponseFromJson(response.body);
  }

     Future<ClassifiedAdsResponse> getOwnClassifiedProducts(
      {
      page = 1,
      }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/classified/own-products?page=$page");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
    });
    print(response.body);
    return classifiedAdsResponseFromJson(response.body);
  }


  Future<ClassifiedAdsResponse> getClassifiedOtherAds(
      {
      id = 1,
      }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/classified/related-products/$id");
    print(url.toString());

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return classifiedAdsResponseFromJson(response.body);
  }

    Future<ClassifiedAdsDetailsResponse> getClassifiedProductsDetails(id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/classified/product-details/$id");
    print(url.toString());

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return classifiedAdsDetailsResponseFromJson(response.body);
  }


    Future<CommonResponse> getDeleteClassifiedProductResponse(id) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/classified/delete/$id");
print(url.toString());

    final response = await http.delete(url, headers: {
      "App-Language": app_language.$,
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
    });

    return commonResponseFromJson(response.body);
  }

    Future<CommonResponse> getStatusChangeClassifiedProductResponse(id,status) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/classified/change-status/$id");

var post_body = jsonEncode({
  "status":status
});
    final response = await http.post(url, headers: {
      "App-Language": app_language.$,
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
    },
      body: post_body,
    );

    return commonResponseFromJson(response.body);
  }



  Future<ProductDetailsResponse> getProductDetails(
      {@required int id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/" + id.toString());
    print(url.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    //print(response.body.toString());
    return productDetailsResponseFromJson(response.body);
  }

    Future<ProductDetailsResponse> getDigitalProductDetails(
      {@required int id = 0}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/" + id.toString());
    print(url.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    //print(response.body.toString());
    return productDetailsResponseFromJson(response.body);
  }



  Future<ProductMiniResponse> getRelatedProducts({@required int id = 0}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/products/related/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts(
      {@required int id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/top-from-seller/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    print("top selling product url ${url.toString()}");
    print("top selling product ${response.body.toString()}");

    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {int id = 0, color = '', variants = ''}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/variant/price?id=${id.toString()}&color=${color}&variants=${variants}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    return variantResponseFromJson(response.body);
  }
}
