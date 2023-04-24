import 'package:active_ecommerce_flutter/data_model/addons_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/addons_repository.dart';

class AddonsHelper{
  setAddonsData()async{
    List<AddonsListResponse> addonsList = await AddonsRepository().getAddonsListResponse();

    addonsList.forEach((element) {
      switch(element.uniqueIdentifier){
        case 'club_point':
          {
            if (element.activated.toString() == "1") {
              club_point_addon_installed.$ = true;
            } else {
              club_point_addon_installed.$ = false;
            }
          }
          break;
        case 'refund_request':
          {
            if (element.activated.toString() == "1") {
              refund_addon_installed.$ = true;
            } else {
              refund_addon_installed.$ = false;
            }
          }
          break;
        case 'otp_system':
          {
            if (element.activated.toString() == "1") {
              otp_addon_installed.$ = true;
            } else {
              otp_addon_installed.$ = false;
            }
          }
          break;
        case 'auction':
          {
            if (element.activated.toString() == "1") {
              auction_addon_installed.$ = true;
            } else {
              auction_addon_installed.$ = false;
            }
          }
          break;

        default:{
        }
          break;
      }
    });
  }
}