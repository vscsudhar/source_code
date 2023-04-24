import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/address_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_add_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_location_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_make_default_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_in_cart_response.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/data_model/shipping_cost_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class AddressRepository {
  Future<dynamic> getAddressList() async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/user/shipping/address");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);
    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return addressResponseFromJson(response.body);
  }

  Future<dynamic> getHomeDeliveryAddress() async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/get-home-delivery-address");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);


    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return addressResponseFromJson(response.body);
  }

  Future<dynamic> getAddressAddResponse(
      {@required String address,
      @required int country_id,
      @required int state_id,
      @required int city_id,
      @required String postal_code,
      @required String phone}) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "address": "$address",
      "country_id": "$country_id",
      "state_id": "$state_id",
      "city_id": "$city_id",
      "postal_code": "$postal_code",
      "phone": "$phone"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/create");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);


    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return addressAddResponseFromJson(response.body);
  }

  Future<dynamic> getAddressUpdateResponse(
      {@required int id,
      @required String address,
      @required int country_id,
      @required int state_id,
      @required int city_id,
      @required String postal_code,
      @required String phone}) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.$}",
      "address": "$address",
      "country_id": "$country_id",
      "state_id": "$state_id",
      "city_id": "$city_id",
      "postal_code": "$postal_code",
      "phone": "$phone"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/update");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);


    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return addressUpdateResponseFromJson(response.body);
  }

  Future<dynamic> getAddressUpdateLocationResponse(
    @required int id,
    @required double latitude,
    @required double longitude,
  ) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.$}",
      "latitude": "$latitude",
      "longitude": "$longitude"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/update-location");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);


    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return addressUpdateLocationResponseFromJson(response.body);
  }

  Future<dynamic> getAddressMakeDefaultResponse(
    @required int id,
  ) async {
    var post_body = jsonEncode({
      "id": "$id",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/make_default");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);
    bool checkResult = ResponseCheck.apply(response.body);


    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return addressMakeDefaultResponseFromJson(response.body);
  }

  Future<dynamic> getAddressDeleteResponse(
    @required int id,
  ) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/user/shipping/delete/$id");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return addressDeleteResponseFromJson(response.body);
  }

  Future<dynamic> getCityListByState({state_id = 0, name = ""}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/cities-by-state/${state_id}?name=${name}");
    final response = await http.get(url);

    bool checkResult = ResponseCheck.apply(response.body);


    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return cityResponseFromJson(response.body);
  }

  Future<dynamic> getStateListByCountry(
      {country_id = 0, name = ""}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/states-by-country/${country_id}?name=${name}");
    final response = await http.get(url);

    bool checkResult = ResponseCheck.apply(response.body);


    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return myStateResponseFromJson(response.body);
  }

  Future<dynamic> getCountryList({name = ""}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/countries?name=${name}");
    final response = await http.get(url);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return countryResponseFromJson(response.body);
  }

  Future<dynamic> getShippingCostResponse(
      {
       shipping_type =""}) async {
    var post_body = jsonEncode({
      "seller_list": shipping_type
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/shipping_cost");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return shippingCostResponseFromJson(response.body);
  }

  Future<dynamic> getAddressUpdateInCartResponse(
      {int address_id = 0, int pickup_point_id = 0}) async {
    var post_body = jsonEncode({
      "address_id": "${address_id}",
      "pickup_point_id": "${pickup_point_id}",
      "user_id": "${user_id.$}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/update-address-in-cart");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return addressUpdateInCartResponseFromJson(response.body);
  }


  Future<dynamic> getShippingTypeUpdateInCartResponse(
      { @required int shipping_id, shipping_type = "home_delivery"}) async {
    var post_body = jsonEncode({
      "shipping_id": "${shipping_id}",
      "shipping_type": "$shipping_type",
    });


    Uri url = Uri.parse("${AppConfig.BASE_URL}/update-shipping-type-in-cart");

    print(url.toString());
    print(post_body.toString());
    print(access_token.$.toString());
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return addressUpdateInCartResponseFromJson(response.body);
  }


}
