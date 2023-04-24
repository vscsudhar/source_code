import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SellerProducts extends StatefulWidget {

  SellerProducts({Key key,this.id, this.shop_name}) : super(key: key);
  final int  id;
  final String  shop_name;

  @override
  _SellerProductsState createState() => _SellerProductsState();
}

class _SellerProductsState extends State<SellerProducts> {

  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  List<dynamic> _productList = [];
  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int _totalData = 0;
  bool _showLoadingContainer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();

      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    var productResponse = await ProductRepository().getShopProducts(id:widget.id,page: _page, name: _searchKey);
    _productList.addAll(productResponse.products);
    _isInitial = false;
    _totalData = productResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async{
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
       // appBar: buildAppBar(context),
        body: Stack(
          children: [
            buildProductList(),
           /* Align(
                alignment: Alignment.bottomCenter,
                child: buildLoadingContainer())*/
          ],
        )
      ),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _productList.length
            ? AppLocalizations.of(context).common_no_more_products
            : AppLocalizations.of(context).common_loading_more_products),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
backgroundColor: Colors.white,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
        width: 250,
        child: TextField(
          controller: _searchController,
          onTap: () {},
          onChanged: (txt){
            /*_searchKey = txt;
              reset();
              fetchData();*/
          },
          onSubmitted: (txt){
            _searchKey = txt;
            reset();
            fetchData();
          },
          autofocus: true,
          decoration: InputDecoration(
              hintText: "${AppLocalizations.of(context).seller_products_screen_search_products_of_shop} : "  + widget.shop_name,
              hintStyle: TextStyle(
                  fontSize: 14.0, color: MyTheme.textfield_grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyTheme.white, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyTheme.white, width: 0.0),
              ),
              contentPadding: EdgeInsets.all(0.0)),
        )),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.search, color: MyTheme.dark_grey),
            onPressed: () {
              _searchKey = _searchController.text.toString();
              setState(() {

              });
              reset();
              fetchData();
            },
          ),
        ),
      ],
    );
  }

   buildProductList() {
     if (_isInitial && _productList.length == 0) {
       return SingleChildScrollView(
           child: ShimmerHelper()
               .buildProductGridShimmer(scontroller: _scrollController));
     }else if(_productList.length > 0){
       return RefreshIndicator(
         color: MyTheme.accent_color,
         backgroundColor: Colors.white,
         displacement: 0,
         onRefresh: _onRefresh,
         child: SingleChildScrollView(
           controller: _xcrollController,
           physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
           child: MasonryGridView.count(
             crossAxisCount: 2,
             mainAxisSpacing: 14,
             crossAxisSpacing: 14,
             itemCount: _productList.length,
             shrinkWrap: true,
             padding: EdgeInsets.only(top:10.0,bottom: 10,left: 18,right:18),
             physics: NeverScrollableScrollPhysics(),
             itemBuilder: (context, index) {
               // 3
               return ProductCard(
                 id: _productList[index].id,
                 image: _productList[index].thumbnail_image,
                 name: _productList[index].name,
                 main_price: _productList[index].main_price,
                 stroked_price: _productList[index].stroked_price,
                 has_discount: _productList[index].has_discount,
                 discount: _productList[index].discount,
               );
             },
           ),
         ),
       );
     }else if (_totalData == 0) {
       return Center(child: Text(AppLocalizations.of(context).common_no_data_available));
     } else {
       return Container(); // should never be happening
     }

  }

}

