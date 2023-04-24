import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/data_model/purchased_ditital_product_response.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/data_model/order_mini_response.dart';
import 'package:active_ecommerce_flutter/data_model/order_detail_response.dart';
import 'package:active_ecommerce_flutter/data_model/order_item_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class OrderRepository {
  Future<dynamic> getOrderList(
      {page = 1, payment_status = "", delivery_status = ""}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/purchase-history" +
        "?page=${page}&payment_status=${payment_status}&delivery_status=${delivery_status}");
    print("url:" +url.toString());
    print("token:" +access_token.$);
    final response = await http.get(url,headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
        });

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return orderMiniResponseFromJson(response.body);
  }

  Future<dynamic> getOrderDetails({@required int id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/purchase-history-details/" + id.toString());

    final response = await http.get(url,headers: {
      "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$,
        });
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return orderDetailResponseFromJson(response.body);
  }

  Future<dynamic> getOrderItems({@required int id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/purchase-history-items/" + id.toString());
    final response = await http.get(url,headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
        });
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return orderItemlResponseFromJson(response.body);
  }

  Future<dynamic> getPurchasedDigitalProducts(
      {
        page = 1,
      }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/digital/purchased-list?page=$page");
    print(url.toString());

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
      "Authorization": "Bearer ${access_token.$}",
    });

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);
    return purchasedDigitalProductResponseFromJson(response.body);
  }
}
