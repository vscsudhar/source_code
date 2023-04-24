import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;

import 'package:active_ecommerce_flutter/data_model/search_suggestion_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class SearchRepository {
  Future<List<SearchSuggestionResponse>> getSearchSuggestionListResponse(
      {query_key = "", type = "product"}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/get-search-suggestions?query_key=$query_key&type=$type");
    final response = await http.get(
      url,
      headers: {
        "App-Language": app_language.$,
      },
    );


    return searchSuggestionResponseFromJson(response.body);
  }
}
