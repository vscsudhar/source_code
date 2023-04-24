import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/wishlist_check_response.dart';
import 'package:active_ecommerce_flutter/data_model/wishlist_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/wishlist_response.dart';
import 'package:flutter/foundation.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class WishListRepository {
  Future<dynamic> getUserWishlist() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/wishlists");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return wishlistResponseFromJson(response.body);
  }

  Future<dynamic> delete({
    @required int wishlist_id = 0,
  }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/wishlists/${wishlist_id}");
    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return wishlistDeleteResponseFromJson(response.body);
  }

  Future<dynamic> isProductInUserWishList(
      {@required product_id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/wishlists-check-product?product_id=${product_id}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return wishListChekResponseFromJson(response.body);
  }

  Future<dynamic> add({@required product_id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/wishlists-add-product?product_id=${product_id}");

    print(url.toString());
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);


    return wishListChekResponseFromJson(response.body);
  }

  Future<dynamic> remove({@required product_id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/wishlists-remove-product?product_id=${product_id}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if(!checkResult)
      return responseCheckModelFromJson(response.body);

    return wishListChekResponseFromJson(response.body);
  }
}
