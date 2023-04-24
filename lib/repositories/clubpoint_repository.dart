import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/data_model/clubpoint_response.dart';
import 'package:active_ecommerce_flutter/data_model/clubpoint_to_wallet_response.dart';

class ClubpointRepository {
  Future<dynamic> getClubPointListResponse(
      {@required page = 1}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/clubpoint/get-list?page=$page");
    print("url(${url.toString()}) access token (Bearer ${access_token.$})");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return clubpointResponseFromJson(response.body);
  }

  Future<dynamic> getClubpointToWalletResponse(
      @required int id) async {
    var post_body = jsonEncode({
      "id": "${id}",
    });
    Uri url = Uri.parse("${AppConfig.BASE_URL}/clubpoint/convert-into-wallet");
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

    return clubpointToWalletResponseFromJson(response.body);
  }
}
