import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';

class AuthHelper {
  setUserData(loginResponse) {
    if (loginResponse.result == true) {
      is_logged_in.$ = true;
      is_logged_in.save();
      access_token.$ = loginResponse.access_token;
      access_token.save();
      user_id.$ = loginResponse.user.id;
      user_id.save();
      user_name.$ = loginResponse.user.name;
      user_name.save();
      user_email.$ = loginResponse.user.email;
      user_email.save();
      user_phone.$ = loginResponse.user.phone;
      user_phone.save();
      avatar_original.$ = loginResponse.user.avatar_original;
      avatar_original.save();
    }
  }

  clearUserData() {
      is_logged_in.$ = false;
      is_logged_in.save();
      access_token.$ = "";
      access_token.save();
      user_id.$ = 0;
      user_id.save();
      user_name.$ = "";
      user_name.save();
      user_email.$ = "";
      user_email.save();
      user_phone.$ = "";
      user_phone.save();
      avatar_original.$ = "";
      avatar_original.save();
  }


  fetch_and_set() async {
    var userByTokenResponse = await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.$ = true;
      is_logged_in.save();
      user_id.$ = userByTokenResponse.id;
      user_id.save();
      user_name.$ = userByTokenResponse.name;
      user_name.save();
      user_email.$ = userByTokenResponse.email;
      user_email.save();
      user_phone.$ = userByTokenResponse.phone;
      user_phone.save();
      avatar_original.$ = userByTokenResponse.avatar_original;
      avatar_original.save();
    }else{
      is_logged_in.$ = false;
      is_logged_in.save();
      user_id.$ = 0;
      user_id.save();
      user_name.$ = "";
      user_name.save();
      user_email.$ = "";
      user_email.save();
      user_phone.$ = "";
      user_phone.save();
      avatar_original.$ = "";
      avatar_original.save();
    }
  }
}
