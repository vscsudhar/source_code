import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TopSellingProducts extends StatefulWidget {
  @override
  _TopSellingProductsState createState() => _TopSellingProductsState();
}

class _TopSellingProductsState extends State<TopSellingProducts> {
  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildProductList(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).top_selling_products_screen_top_selling_products,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: ProductRepository().getBestSellingProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            //print("product error");
            //print(snapshot.error.toString());
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            //print(productResponse.toString());
            return SingleChildScrollView(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                itemCount: productResponse.products.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20.0, bottom: 10, left: 18, right: 18),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // 3
                  return ProductCard(
                    id: productResponse.products[index].id,
                    image: productResponse.products[index].thumbnail_image,
                    name: productResponse.products[index].name,
                    main_price: productResponse.products[index].main_price,
                    stroked_price:
                        productResponse.products[index].stroked_price,
                    has_discount: productResponse.products[index].has_discount,
                    discount: productResponse.products[index].discount,
                  );
                },
              ),
            );
          } else {
            return ShimmerHelper()
                .buildProductGridShimmer(scontroller: _scrollController);
          }
        });
  }
}
