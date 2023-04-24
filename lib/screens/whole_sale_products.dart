import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/repositories/wishlist_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/string_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:toast/toast.dart';

class WholeSaleProducts extends StatefulWidget {
  WholeSaleProducts(
      {Key key,})
      : super(key: key);

  @override
  _WholeSaleProductsState createState() => _WholeSaleProductsState();
}

class _WholeSaleProductsState extends State<WholeSaleProducts> {
  ScrollController _mainScrollController = ScrollController();

  //init
  bool _dataFetch = false;
  List<dynamic> _digitalProductItems = [];

  @override
  void initState() {
      fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }


  reset() {
    _dataFetch = false;
    _digitalProductItems.clear();
    setState(() {});
  }

  fetchData()async{
    var wishlistResponse = await WishListRepository().getUserWishlist();
    _digitalProductItems.addAll(wishlistResponse.wishlist_items);
    _dataFetch = true;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: body(),
      ),
    );
  }

  bool shouldProductBoxBeVisible(product_name, search_key) {
    if (search_key == "") {
      return true; //do not check if the search key is empty
    }
    return StringHelper().stringContains(product_name, search_key);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading:UsefulElements.backButton(context),
      title: Text(
        AppLocalizations.of(context).whole_sale_product_screen_title,
        style: TextStyle(fontSize: 16, color: MyTheme.dark_font_grey,fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }


 Widget body(){

    if(!_dataFetch){
      return ShimmerHelper()
          .buildProductGridShimmer(scontroller: _mainScrollController);
    }

    if(_digitalProductItems.length==0){
      return Center(child: Text(LangText(context).local.common_no_data_available),);
    }
    return RefreshIndicator(
      onRefresh: _onPageRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          itemCount: _digitalProductItems.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(
              top: 10.0, bottom: 10, left: 18, right: 18),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            // 3
            return ProductCard(
                id: _digitalProductItems[index].id,
                image: _digitalProductItems[index].product.thumbnail_image,
                name: _digitalProductItems[index].product.name,
                main_price: _digitalProductItems[index].product.base_price,
                //stroked_price: _digitalProductItems[index].product.stroked_price,
                has_discount: false
            );
          },
        ),
      ),
    );

  }

}
