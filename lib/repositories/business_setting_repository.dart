import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/business_setting_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BusinessSettingRepository{
  Future<List<BusinessSettingListResponse>> getBusinessSettingList()async{
    Uri url = Uri.parse("${AppConfig.BASE_URL}/business-settings");

   var businessSettings = [
      "facebook_login",
      "google_login",
      "twitter_login",
      "pickup_point",
     "wallet_system",
     "email_verification",
     "conversation_system",
     "shipping_type",
     "classified_product"
    ];
  String params= businessSettings.join(',');
    var body = {
      //'keys':params
      "keys":params
    };
    //print("business ${body}");
    var response = await http.post(url,body: body);

    print("business ${response.body}");

    return businessSettingListResponseFromJson(response.body);
  }
}