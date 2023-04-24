import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/screens/seller_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/list_product_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/mini_product_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:active_ecommerce_flutter/repositories/shop_repository.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SellerDetails extends StatefulWidget {
  int id;

  SellerDetails({Key key, this.id}) : super(key: key);

  @override
  _SellerDetailsState createState() => _SellerDetailsState();
}

class _SellerDetailsState extends State<SellerDetails> {
  ScrollController _mainScrollController = ScrollController();
  // ScrollController _scrollController = ScrollController();

  //init
  int _current_slider = 0;
  List<dynamic> _carouselImageList = [];
  bool _carouselInit = false;
  var _shopDetails = null;

  List<dynamic> _newArrivalProducts = [];
  bool _newArrivalProductInit = false;
  List<dynamic> _topProducts = [];
  bool _topProductInit = false;
  List<dynamic> _featuredProducts = [];
  bool _featuredProductInit = false;

  List<dynamic> _allProductList = [];
  bool _isInitialAllProduct = true;
  int _page = 1;
  // ScrollController _scrollController = ScrollController();

  int tabOptionIndex = 0;

  @override
  void initState() {
    fetchAll();

    _mainScrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        if(tabOptionIndex ==2) {

          print("object");
          setState(() {
          _page++;
        });
          fetchAllProductData();
        }


      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _mainScrollController.dispose();

    super.dispose();
  }


  fetchAllProductData() async {
    var productResponse = await ProductRepository().getShopProducts(id:widget.id,page: _page,);
    _allProductList.addAll(productResponse.products);
    _allProductList.addAll(productResponse.products);
    _isInitialAllProduct = false;
    setState(() {});
  }
  
  fetchAll() {
    fetchShopDetails();
    fetchNewArrivalProducts();
    fetchTopProducts();
    fetchFeaturedProducts();
    fetchAllProductData();
  }

  fetchShopDetails() async {
    var shopDetailsResponse = await ShopRepository().getShopInfo(id: widget.id);

    //print('ss:' + shopDetailsResponse.toString());
    if (shopDetailsResponse.shop !=null) {
      _shopDetails = shopDetailsResponse.shop;
    }

    if (_shopDetails != null) {
      _shopDetails.sliders.forEach((slider) {
        _carouselImageList.add(slider);
      });
    }
    _carouselInit = true;

    setState(() {});
  }

  fetchNewArrivalProducts() async {
    var newArrivalProductResponse =
        await ShopRepository().getNewFromThisSellerProducts(id: widget.id);
    _newArrivalProducts.addAll(newArrivalProductResponse.products);
    _newArrivalProductInit = true;

    setState(() {});
  }

  fetchTopProducts() async {
    var topProductResponse =
        await ShopRepository().getTopFromThisSellerProducts(id: widget.id);
    _topProducts.addAll(topProductResponse.products);
    _topProductInit = true;
  }

  fetchFeaturedProducts() async {
    var featuredProductResponse =
        await ShopRepository().getfeaturedFromThisSellerProducts(id: widget.id);
    _featuredProducts.addAll(featuredProductResponse.products);
    _featuredProductInit = true;
  }

  reset() {
    _shopDetails = null;
    _carouselImageList.clear();
    _carouselInit = false;
    _newArrivalProducts.clear();
    _topProducts.clear();
    _featuredProducts.clear();
    _topProductInit = false;
    _newArrivalProductInit = false;
    _featuredProductInit = false;

     _allProductList.clear();
     _isInitialAllProduct = true;
     _page = 1;

    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          appBar: buildAppBar(context),
          //bottomNavigationBar: buildBottomAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    buildCarouselSlider(context),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        18.0,
                        16.0,
                        18.0,
                        0.0,
                      ),
                      child: _shopDetails == null
                          ? buildShopDetailsShimmer()
                          : buildShopDetails(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        18.0,
                        20.0,
                        18.0,
                        0.0,
                      ),
                      child: _shopDetails == null
                          ? buildTabOptionShimmer(context)
                          : buildTabOption(context),
                    ),
                    buildTabBarBody(context)
                  ]),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildTabBarBody(BuildContext context) {

    if(tabOptionIndex==1){
     return
       // false
     _shopDetails !=null
         ?
       buildTopSelling(context):ShimmerHelper().buildProductGridShimmer();
    }
       if(tabOptionIndex==2){
     return
       // false
       _shopDetails !=null
           ?
       buildAllProducts(context):
     ShimmerHelper().buildProductGridShimmer();
    }

   return
     //false
     _shopDetails !=null
       ?
   buildStoreHome(context):
   buildStoreHomeShimmer(context);
  }

  Container buildTopSelling(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              18.0,
              20.0,
              18.0,
              0.0,
            ),
            child: Text(
              AppLocalizations.of(context).top_selling_products_screen_top_selling_products,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          buildTopSellingProducts(),
        ],
      ),
    );
  }

  Container buildAllProducts(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              18.0,
              20.0,
              18.0,
              0.0,
            ),
            child: Text(
              AppLocalizations.of(context).home_screen_all_products,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          buildAllProductList(),
        ],
      ),
    );
  }

  Widget buildStoreHome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFeaturedProductsSection(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            18.0,
            20.0,
            18.0,
            0.0,
          ),
          child: Text(
            AppLocalizations.of(context).seller_details_screen_new_arrivals,
            style: TextStyle(
                color: MyTheme.font_grey,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
        buildNewArrivalProducts(context),
      ],
    );
  }
  Widget buildStoreHomeShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFeaturedProductsShimmerSection(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            18.0,
            20.0,
            18.0,
            0.0,
          ),

          child: ShimmerHelper().buildBasicShimmer(height: 15,width:90,radius: 0),
        ),
        ShimmerHelper().buildProductGridShimmer(),
      ],
    );
  }

  Widget buildFeaturedProductsSection() {
    return Container(
      margin: EdgeInsets.only(
        top: 20.0,
      ),
      height: 280,
      decoration: BoxDecoration(
          color: MyTheme.dark_font_grey,
          image: DecorationImage(image: AssetImage("assets/background_1.png"))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 20),
            child: Text(
              LangText(context).local.home_screen_featured_products,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.white),
            ),
          ),
          Container(
            height: 239,
            padding: EdgeInsets.only(top: 10,bottom: 20),
            width: double.infinity,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 18),
                itemBuilder: (context, index) {
                  return Container(
                    height: 196,
                    width: 124,
                    child: ProductCard(
                        id: _featuredProducts[index].id,
                        image: _featuredProducts[index].thumbnail_image,
                        name: _featuredProducts[index].name,
                        main_price: _featuredProducts[index].main_price,
                        stroked_price: _featuredProducts[index].stroked_price,
                        has_discount: _featuredProducts[index].has_discount),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    width: 14,
                  );
                },
                itemCount: _featuredProducts.length),
          )
        ],
      ),
    );
  }

  Widget buildFeaturedProductsShimmerSection() {
    return Container(
      margin: EdgeInsets.only(
        top: 20.0,
      ),
      height: 280,
      decoration: BoxDecoration(
          color: MyTheme.dark_font_grey,
          image: DecorationImage(image: AssetImage("assets/background_1.png"))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 20),
            child: Column(
              children: [
                ShimmerHelper().buildBasicShimmer(height: 15,width: 90,radius: 0),
              ],
            ),
          ),
          Container(
            height: 239,
            padding: EdgeInsets.only(top: 10,bottom: 20),
            width: double.infinity,
            child: ListView.separated(
              itemCount: 10,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 18),
                itemBuilder: (context, index) {
                  return Container(
                    height: 196,
                    width: 124,
                    child:  ShimmerHelper().buildBasicShimmer(height: 196,width: 124),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    width: 14,
                  );
                },
                ),
          )
        ],
      ),
    );
  }

  Widget buildTabOption(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTabOptionItem(
            context,
            0,
            LangText(context).local.seller_details_screen_store_home,
          ),
          buildTabOptionItem(
            context,
            1,
            LangText(context).local.seller_details_screen_top_selling,
          ),
          buildTabOptionItem(
            context,
            2,
            LangText(context).local.home_screen_all_products,
          ),
        ],
      ),
    );
  }

  Widget buildTabOptionShimmer(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            height: 30,
            width: DeviceInfo(context).width / 4,
            decoration: BoxDecorations.buildBoxDecoration_1(),
            child: ShimmerHelper().buildBasicShimmer(
              height: 30,
              width: DeviceInfo(context).width / 4,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            height: 30,
            width: DeviceInfo(context).width / 4,
            decoration: BoxDecorations.buildBoxDecoration_1(),
            child: ShimmerHelper().buildBasicShimmer(
              height: 30,
              width: DeviceInfo(context).width / 4,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            height: 30,
            width: DeviceInfo(context).width / 4,
            decoration: BoxDecorations.buildBoxDecoration_1(),
            child: ShimmerHelper().buildBasicShimmer(
              height: 30,
              width: DeviceInfo(context).width / 4,
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildTabOptionItem(
      BuildContext context, index, String text) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      height: 30,
      width: DeviceInfo(context).width / 4,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: FlatButton(
        padding: EdgeInsets.zero,
        color: tabOptionIndex == index
            ? MyTheme.accent_color
            : MyTheme.white,
        textColor: tabOptionIndex == index
            ? MyTheme.white
            : MyTheme.dark_font_grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onPressed: () {
          tabOptionIndex = index;
          setState(() {});
        },
        child: Text(
          text,
          style: TextStyle(
              fontSize: 10,
              fontWeight: tabOptionIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal),
        ),
      ),
    );
  }

  buildCarouselSlider(context) {
    if (_shopDetails == null) {
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShimmerHelper().buildBasicShimmer(
            height: 100.0,
          ));
    } else if (_carouselImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
            height: 140,
            aspectRatio: 3.7,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInExpo,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current_slider = index;
              });
            }),
        items: _carouselImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(
                children: <Widget>[
                  Container(
                      height: 140,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      decoration: BoxDecorations.buildBoxDecoration_1(),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: i,
                            fit: BoxFit.cover,
                          ))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _carouselImageList.map((url) {
                        int index = _carouselImageList.indexOf(url);
                        return Container(
                          width: 7.0,
                          height: 7.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current_slider == index
                                ? MyTheme.white
                                : Color.fromRGBO(112, 112, 112, .3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _shopDetails != null
                ? buildShowProductsButton(context)
                : Container()
          ],
        ),
      ),
    );
  }

  buildShowProductsButton(BuildContext context) {
    return FlatButton(
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      color: MyTheme.accent_color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Text(
        AppLocalizations.of(context)
            .seller_details_screen_btn_view_all_products,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SellerProducts(
            id: _shopDetails.id,
            shop_name: _shopDetails.name,
          );
        }));
      },
    );
  }

  Widget buildTopSellingProducts() {
    return  MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        itemCount: _topProducts.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ProductCard(
              id: _topProducts[index].id,
              image: _topProducts[index].thumbnail_image,
              name: _topProducts[index].name,
              main_price: _topProducts[index].main_price,
              stroked_price: _topProducts[index].stroked_price,
              has_discount: _topProducts[index].has_discount,
              discount: _topProducts[index].discount,
          );
        });
  }

  Widget buildNewArrivalProducts(context) {
    if (_newArrivalProductInit && _newArrivalProducts.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer());
    } else if (_newArrivalProducts.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          itemCount: _newArrivalProducts.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ProductCard(
                id: _newArrivalProducts[index].id,
                image: _newArrivalProducts[index].thumbnail_image,
                name: _newArrivalProducts[index].name,
                main_price: _newArrivalProducts[index].main_price,
                stroked_price: _newArrivalProducts[index].stroked_price,
                has_discount: _newArrivalProducts[index].has_discount,
                discount: _newArrivalProducts[index].discount,
            );
          });
    } else if (_newArrivalProducts.length == 0) {
      return Center(
          child: Text(
              AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }


  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 75,
      leading: Builder(
        builder: (context) => IconButton(
          padding: EdgeInsets.zero,
          icon: UsefulElements.backButton(context),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
        child: Container(
            width: 350,
            child:
                //false
                _shopDetails != null
                    ? buildAppbarShopTitle()
                    : Row(
                        children: [
                          ShimmerHelper().buildBasicShimmer(
                              height: 40.0,
                              width: DeviceInfo(context).width - 70),
                          /*Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerHelper()
                                .buildBasicShimmer(height: 25.0, width: 150.0),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ShimmerHelper().buildBasicShimmer(
                                  height: 20.0, width: 100.0),
                            ),
                          ],
                        ),
                      )*/
                        ],
                      )),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      /* actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.location_on, color: MyTheme.dark_grey),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => Directionality(
                        textDirection: app_language_rtl.$
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: AlertDialog(
                          contentPadding: EdgeInsets.only(
                              top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
                          content: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              _shopDetails.address,
                              maxLines: 3,
                              style: TextStyle(
                                  color: MyTheme.font_grey, fontSize: 14),
                            ),
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                AppLocalizations.of(context)
                                    .common_close_in_all_capital,
                                style: TextStyle(color: MyTheme.medium_grey),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                          ],
                        ),
                      ));
            },
          ),
        ),
      ],*/
    );
  }

  Widget buildShopDetails() {
    return Container(
      //color: Colors.red,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: _shopDetails.logo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: DeviceInfo(context).width / 2,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _shopDetails.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  buildRatingWithCountRow(),
                  Text(
                    _shopDetails.address,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 10,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Spacer(),
            /*Container(
              height: 30,
              width: 90,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: FlatButton(
                padding: EdgeInsets.zero,
                color: MyTheme.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: MyTheme.golden)),
                onPressed: () {},
                child: Text(
                  LangText(context).local.common_follow,
                  style: TextStyle(fontSize: 10, color: MyTheme.golden),
                ),
              ),
            )*/
          ]),
    );
  }

  Widget buildShopDetailsShimmer() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecorations.buildBoxDecoration_1(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ShimmerHelper().buildBasicShimmer(height: 60, width: 60),
            ),
          ),
          Container(
            //color: Colors.amber,
            padding: EdgeInsets.only(left: 10),
            width: DeviceInfo(context).width / 2,
            height: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerHelper().buildBasicShimmer(
                    height: 16, width: DeviceInfo(context).width / 4),
                ShimmerHelper().buildBasicShimmer(
                    height: 16, width: DeviceInfo(context).width / 4),
                ShimmerHelper().buildBasicShimmer(
                    height: 16, width: DeviceInfo(context).width / 4),
              ],
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecorations.buildBoxDecoration_1(),
            child: ShimmerHelper().buildBasicShimmer(
                height: 30, width: DeviceInfo(context).width / 4),
          )
        ]);
  }

  buildAppbarShopTitle() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Container(
        width: DeviceInfo(context).width - 70,
        child: Text(
          _shopDetails.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              color: MyTheme.dark_font_grey,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    ]);
  }

  Row buildRatingWithCountRow() {
    return Row(
      children: [
        RatingBar(
          itemSize: 14.0,
          ignoreGestures: true,
          initialRating: double.parse(_shopDetails.rating.toString()),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: Icon(FontAwesome.star, color: Colors.amber),
            half: Icon(FontAwesome.star_half, color: Colors.amber),
            empty:
                Icon(FontAwesome.star, color: Color.fromRGBO(224, 224, 225, 1)),
          ),
          itemPadding: EdgeInsets.only(right: 4.0),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
      ],
    );
  }


  Widget buildAllProductList() {
    return  MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        itemCount: _allProductList.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ProductCard(
              id: _allProductList[index].id,
              image: _allProductList[index].thumbnail_image,
              name: _allProductList[index].name,
              main_price: _allProductList[index].main_price,
              stroked_price: _allProductList[index].stroked_price,
              has_discount: _allProductList[index].has_discount,
              discount: _allProductList[index].discount,
          );
        });
  }
}
