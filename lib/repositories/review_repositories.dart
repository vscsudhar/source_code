import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/review_response.dart';
import 'package:active_ecommerce_flutter/data_model/review_submit_response.dart';

import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class ReviewRepository {
  Future<dynamic> getReviewResponse(@required int product_id,{page = 1}) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/reviews/product/${product_id}?page=${page}");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return reviewResponseFromJson(response.body);
  }

  Future<dynamic> getReviewSubmitResponse(
      @required int product_id,
      @required int rating,
      @required String comment,
      ) async {
    var post_body = jsonEncode({
      "product_id": "${product_id}",
      "user_id": "${user_id.$}",
      "rating": "$rating",
      "comment": "$comment"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/reviews/submit");
    final response =
    await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,
        },
        body: post_body);

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return reviewSubmitResponseFromJson(response.body);
  }


}
