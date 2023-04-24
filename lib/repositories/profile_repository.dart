import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/data_model/profile_image_update_response.dart';
import 'package:active_ecommerce_flutter/data_model/user_info_response.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/profile_counters_response.dart';
import 'package:active_ecommerce_flutter/data_model/profile_update_response.dart';
import 'package:active_ecommerce_flutter/data_model/device_token_update_response.dart';
import 'package:active_ecommerce_flutter/data_model/phone_email_availability_response.dart';

import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {


  Future<dynamic> getProfileCountersResponse() async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/counters");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,
      },
    );

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return profileCountersResponseFromJson(response.body);
  }

  Future<dynamic> getProfileUpdateResponse(
      {String post_body}) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/update");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,},body: post_body );

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return profileUpdateResponseFromJson(response.body);
  }

  Future<dynamic> getDeviceTokenUpdateResponse(
      @required String device_token) async {

    var post_body = jsonEncode({"device_token": "${device_token}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/update-device-token");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,},body: post_body );

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return deviceTokenUpdateResponseFromJson(response.body);
  }

  Future<dynamic> getProfileImageUpdateResponse(
      @required String image,@required String filename) async {

    var post_body = jsonEncode({"image": "${image}", "filename": "$filename"});
    print(post_body.toString());

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/update-image");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,},body: post_body );

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return profileImageUpdateResponseFromJson(response.body);
  }

  Future<dynamic> getPhoneEmailAvailabilityResponse() async {

    //var post_body = jsonEncode({"user_id":"${user_id.$}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/check-phone-and-email");
    final response = await http.post(url,
        headers: {"Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,});

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return phoneEmailAvailabilityResponseFromJson(response.body);
  }


    Future<dynamic> getUserInfoResponse() async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/customer/info");

    final response = await http.get(url,
        headers: {"Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,});

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return userInfoResponseFromJson(response.body);
  }



}
