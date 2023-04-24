import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/text_styles.dart';
import 'package:active_ecommerce_flutter/data_model/classified_ads_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/classified_ads_response.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/common_webview_screen.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/product_reviews.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:active_ecommerce_flutter/ui_elements/classified_product_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/classified_product_mini_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/list_product_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/mini_product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:expandable/expandable.dart';
import 'dart:ui';
import 'package:flutter_html/flutter_html.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/repositories/wishlist_repository.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/color_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:active_ecommerce_flutter/screens/chat.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:toast/toast.dart';
import 'package:social_share/social_share.dart';
import 'dart:async';
import 'package:active_ecommerce_flutter/screens/video_description_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:active_ecommerce_flutter/screens/brand_products.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassifiedAdsDetails extends StatefulWidget {
  int id;

  ClassifiedAdsDetails({Key key, this.id}) : super(key: key);

  @override
  _ClassifiedAdsDetailsState createState() => _ClassifiedAdsDetailsState();
}

class _ClassifiedAdsDetailsState extends State<ClassifiedAdsDetails>
    with TickerProviderStateMixin {
  bool _showCopied = false;
  bool showPhone = false;
  int _currentImage = 0;
  ScrollController _mainScrollController =
      ScrollController(initialScrollOffset: 0.0);

  ScrollController _variantScrollController = ScrollController();
  ScrollController _imageScrollController = ScrollController();

  double _scrollPosition = 0.0;

  Animation _colorTween;
  AnimationController _ColorAnimationController;

  CarouselController _carouselController = CarouselController();

  //init values

  bool _isInWishList = false;
  var _productDetailsFetched = false;
  ClassifiedAdsData _productDetails = null;

  var _productImageList = [];

  double opacity = 0;

  List<ClassifiedAdsMiniData> _relatedProducts = [];
  bool _relatedProductInit = false;


  @override
  void dispose() {
    _mainScrollController.dispose();
    _variantScrollController.dispose();
    _imageScrollController.dispose();
    // _colorScrollController.dispose();
    super.dispose();
  }

  fetchAll() {
    fetchProductDetails();

    fetchRelatedProducts();
  }

  fetchProductDetails() async {
    var productDetailsResponse =
        await ProductRepository().getClassifiedProductsDetails(widget.id);

    if (productDetailsResponse.data.length > 0) {
      _productDetails = productDetailsResponse.data.first;
      _productDetails.photos.forEach((element) {
        _productImageList.add(element.path);
      });
    }

    setState(() {});
  }

  fetchRelatedProducts() async {
    var relatedProductResponse =
        await ProductRepository().getClassifiedOtherAds(id: widget.id);

    _relatedProducts.addAll(relatedProductResponse.data);
    print(_relatedProducts.length.toString()+"ddd");
    _relatedProductInit = true;

    setState(() {});
  }

  reset() {
    _currentImage = 0;
    _productImageList.clear();
    _relatedProducts.clear();
    _productDetailsFetched = false;
    _productDetails = null;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onCopyTap(setState) {
    setState(() {
      _showCopied = true;
    });
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _showCopied = false;
      });
    });
  }

  onPressShare(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: FlatButton(
                          minWidth: 75,
                          height: 26,
                          color: Color.fromRGBO(253, 253, 253, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          child: Text(
                            AppLocalizations.of(context)
                                .product_details_screen_copy_product_link,
                            style: TextStyle(
                              color: MyTheme.medium_grey,
                            ),
                          ),
                          onPressed: () {
                            onCopyTap(setState);
                            SocialShare.copyToClipboard(_productDetails.link);
                          },
                        ),
                      ),
                      _showCopied
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                AppLocalizations.of(context).common_copied,
                                style: TextStyle(
                                    color: MyTheme.medium_grey, fontSize: 12),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: FlatButton(
                          minWidth: 75,
                          height: 26,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          child: Text(
                            AppLocalizations.of(context)
                                .product_details_screen_share_options,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            print("share links ${_productDetails.link}");
                            SocialShare.shareOptions(_productDetails.link);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: app_language_rtl.$
                          ? EdgeInsets.only(left: 8.0)
                          : EdgeInsets.only(right: 8.0),
                      child: FlatButton(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.font_grey, width: 1.0)),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            );
          });
        });
  }

  @override
  void initState() {
    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_ColorAnimationController);

    _mainScrollController.addListener(() {
      _scrollPosition = _mainScrollController.position.pixels;

      if (_mainScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (100 > _scrollPosition && _scrollPosition > 1) {
          opacity = _scrollPosition / 100;
        }
      }

      if (_mainScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (100 > _scrollPosition && _scrollPosition > 1) {
          opacity = _scrollPosition / 100;

          if (100 > _scrollPosition) {
            opacity = 1;
          }
        }
      }
      print("opachity{} $_scrollPosition");

      setState(() {});
    });
    fetchAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          extendBody: true,
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.white.withOpacity(opacity),
                  pinned: true,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      Builder(
                        builder: (context) => InkWell(
                          onTap: () {
                            return Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecorations
                                .buildCircularButtonDecoration_1(),
                            width: 36,
                            height: 36,
                            child: Center(
                              child: Icon(
                                CupertinoIcons.arrow_left,
                                color: MyTheme.dark_font_grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                          opacity: _scrollPosition > 350 ? 1 : 0,
                          duration: Duration(milliseconds: 200),
                          child: Container(
                              width: DeviceInfo(context).width / 1.8,
                              child: Text(
                                "${_productDetails != null ? _productDetails.name : ''}",
                                style: TextStyle(
                                    color: MyTheme.dark_font_grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ))),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          onPressShare(context);
                        },
                        child: Container(
                          decoration:
                              BoxDecorations.buildCircularButtonDecoration_1(),
                          width: 36,
                          height: 36,
                          child: Center(
                            child: Icon(
                              Icons.share_outlined,
                              color: MyTheme.dark_font_grey,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  expandedHeight: 375.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: buildProductSliderImageSection(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    //padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecorations.buildBoxDecoration_1(),
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 14, left: 14, right: 14),
                          child: _productDetails != null
                              ? Text(
                                  _productDetails.name,
                                  style: TextStyles.smallTitleTexStyle(),
                                  maxLines: 2,
                                )
                              : ShimmerHelper().buildBasicShimmer(
                                  height: 30.0,
                                ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 14, left: 14, right: 14),
                          child: _productDetails != null
                              ? buildMainPriceRow()
                              : ShimmerHelper().buildBasicShimmer(
                                  height: 30.0,
                                ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 14, left: 14, right: 14),
                          child: _productDetails != null
                              ? buildBrandRow()
                              : ShimmerHelper().buildBasicShimmer(
                                  height: 50.0,
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14),
                          child: _productDetails != null
                              ? buildSellerRow(context)
                              : ShimmerHelper().buildBasicShimmer(
                                  height: 50.0,
                                ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 14, left: 10, right: 14),
                          child: _productDetails != null
                              ? buildLocationContainer(context)
                              : ShimmerHelper().buildBasicShimmer(
                                  height: 30.0,
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 14, left: 10, right: 14, bottom: 20),
                          child: _productDetails != null
                              ? buildContractContainer(context)
                              : ShimmerHelper().buildBasicShimmer(
                                  height: 30.0,
                                ),
                        ),
                        /* Padding(
                          padding:
                              EdgeInsets.only(top: 14, left: 14, right: 14),
                          child: _productDetails != null
                              ? buildQuantityRow()
                              : ShimmerHelper().buildBasicShimmer(
                                  height: 30.0,
                                ),
                        ),*/
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: MyTheme.white,
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16.0,
                                  20.0,
                                  16.0,
                                  0.0,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .product_details_screen_description,
                                  style: TextStyle(
                                      color: MyTheme.dark_font_grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  8.0,
                                  0.0,
                                  8.0,
                                  8.0,
                                ),
                                child: _productDetails != null
                                    ? buildExpandableDescription()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8.0),
                                        child:
                                            ShimmerHelper().buildBasicShimmer(
                                          height: 60.0,
                                        )),
                              ),
                            ],
                          ),
                        ),
                        divider(),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url:
                                    "${AppConfig.RAW_BASE_URL}/mobile-page/seller-policy",
                                page_name: AppLocalizations.of(context)
                                    .product_details_screen_seller_policy,
                              );
                            }));
                          },
                          child: Container(
                            color: MyTheme.white,
                            height: 48,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                18.0,
                                14.0,
                                18.0,
                                14.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .product_details_screen_seller_policy,
                                    style: TextStyle(
                                        color: MyTheme.dark_font_grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/arrow.png",
                                    height: 11,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        divider(),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url:
                                    "${AppConfig.RAW_BASE_URL}/mobile-page/return-policy",
                                page_name: AppLocalizations.of(context)
                                    .product_details_screen_return_policy,
                              );
                            }));
                          },
                          child: Container(
                            color: MyTheme.white,
                            height: 48,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                18.0,
                                14.0,
                                18.0,
                                14.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .product_details_screen_return_policy,
                                    style: TextStyle(
                                        color: MyTheme.dark_font_grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/arrow.png",
                                    height: 11,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        divider(),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url:
                                    "${AppConfig.RAW_BASE_URL}/mobile-page/support-policy",
                                page_name: AppLocalizations.of(context)
                                    .product_details_screen_support_policy,
                              );
                            }));
                          },
                          child: Container(
                            color: MyTheme.white,
                            height: 48,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                18.0,
                                14.0,
                                18.0,
                                14.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .product_details_screen_support_policy,
                                    style: TextStyle(
                                        color: MyTheme.dark_font_grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "assets/arrow.png",
                                    height: 11,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        divider(),
                      ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        18.0,
                        24.0,
                        18.0,
                        0.0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .product_details_screen_other_ads_of+" "+(_productDetails != null ?_productDetails.category:""),
                        style: TextStyle(
                            color: MyTheme.dark_font_grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: 400,
                      height: 240,
                        child: buildProductsMayLikeList())
                  ]),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildLocationContainer(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 24,
        ),
        SizedBox(
          width: 10,
        ),
        Container(
            width: DeviceInfo(context).width / 1.3,
            child: Text(
              _productDetails.location,
              style: TextStyle(fontSize: 12, color: MyTheme.dark_font_grey),
            ))
      ],
    );
  }

  Widget buildContractContainer(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.phone,
          size: 24,
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: DeviceInfo(context).width / 2,
          child: InkWell(
            onTap: (){
              showPhone=!showPhone;
              setState((){});
            },
            child: Text(
              showPhone? _productDetails.phone:"01XXXXXXXXX",
              style: TextStyle(fontSize: 12, color: MyTheme.dark_font_grey),
            ),
          ),
        ),
        Spacer(),

        Material(
          elevation: 8,
          color: MyTheme.accent_color,

          borderRadius: BorderRadius.circular(50),
          child: IconButton(
              onPressed: () {
                launchUrl(Uri.parse("tel://${_productDetails.phone}"));
              },
              icon: Icon(Icons.phone_forwarded,color: MyTheme.white,)),
        )
      ],
    );
  }

  Row buildMainPriceRow() {
    return Row(
      children: [
        Text(
          _productDetails.unitPrice,
          style: TextStyle(
              color: MyTheme.accent_color,
              fontSize: 16.0,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget buildSellerRow(BuildContext context) {
    //print("sl:" +  _productDetails.shop_logo);
    return Container(
      color: MyTheme.light_grey,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * (.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).product_details_screen_seller,
                    style: TextStyle(
                      color: Color.fromRGBO(153, 153, 153, 1),
                    )),
                Text(
                  _productDetails.addedBy,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalPriceRow() {
    return Container(
      height: 40,
      color: MyTheme.amber,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            child: Padding(
              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: Container(
                width: 75,
                child: Text(
                  AppLocalizations.of(context)
                      .product_details_screen_total_price,
                  style: TextStyle(
                      color: Color.fromRGBO(153, 153, 153, 1), fontSize: 10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              _productDetails.unitPrice,
              style: TextStyle(
                  color: MyTheme.accent_color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Padding buildVariantShimmers() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        0.0,
        8.0,
        0.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildBrandRow() {
    return _productDetails.brand.id > 0
        ? InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BrandProducts(
                  id: _productDetails.brand.id,
                  brand_name: _productDetails.brand.name,
                );
              }));
            },
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 75,
                    child: Text(
                      AppLocalizations.of(context).product_details_screen_brand,
                      style: TextStyle(
                          color: Color.fromRGBO(
                            153,
                            153,
                            153,
                            1,
                          ),
                          fontSize: 10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    _productDetails.brand.name,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                ),
                /*Spacer(),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                    //shape: BoxShape.rectangle,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: _productDetails.brand.logo,
                        fit: BoxFit.contain,
                      )),
                ),*/
              ],
            ),
          )
        : Container();
  }

  ExpandableNotifier buildExpandableDescription() {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: Container(
                height: 50, child: Html(data: _productDetails.description)),
            expanded: Container(child: Html(data: _productDetails.description)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Builder(
                builder: (context) {
                  var controller = ExpandableController.of(context);
                  return FlatButton(
                    child: Text(
                      !controller.expanded
                          ? AppLocalizations.of(context).common_view_more
                          : AppLocalizations.of(context).common_show_less,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 11),
                    ),
                    onPressed: () {
                      controller.toggle();
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }

Widget  buildProductsMayLikeList() {
    if (_relatedProductInit == false && _relatedProducts.length == 0) {
      return Row(
        children: [
          Padding(
              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_relatedProductInit && _relatedProducts.length > 0) {
      return SizedBox(
        height: 248,
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            width: 16,
          ),
          padding: const EdgeInsets.all(16),
          itemCount: _relatedProducts.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ClassifiedMiniProductCard(
              id: _relatedProducts[index].id,
              image: _relatedProducts[index].thumbnailImage,
              name: _relatedProducts[index].name,
              unit_price: _relatedProducts[index].unitPrice,
              condition: _relatedProducts[index].condition,
            );
          },
        ),
      );

    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)
                .product_details_screen_no_related_product,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  openPhotoDialog(BuildContext context, path) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
                child: Stack(
              children: [
                PhotoView(
                  enableRotation: true,
                  heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                  imageProvider: NetworkImage(path),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: MyTheme.medium_grey_50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: Icon(Icons.clear, color: MyTheme.white),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ),
                ),
              ],
            )),
          );
        },
      );

  buildProductImageSection() {
    if (_productImageList.length == 0) {
      return Row(
        children: [
          Container(
            width: 40,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 190.0,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            width: 64,
            child: Scrollbar(
              controller: _imageScrollController,
              isAlwaysShown: false,
              thickness: 4.0,
              child: Padding(
                padding: app_language_rtl.$
                    ? EdgeInsets.only(left: 8.0)
                    : EdgeInsets.only(right: 8.0),
                child: ListView.builder(
                    itemCount: _productImageList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int itemIndex = index;
                      return GestureDetector(
                        onTap: () {
                          _currentImage = itemIndex;
                          print(_currentImage);
                          setState(() {});
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: _currentImage == itemIndex
                                    ? MyTheme.accent_color
                                    : Color.fromRGBO(112, 112, 112, .3),
                                width: _currentImage == itemIndex ? 2 : 1),
                            //shape: BoxShape.rectangle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  /*Image.asset(
                                        singleProduct.product_images[index])*/
                                  FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: _productImageList[index],
                                fit: BoxFit.contain,
                              )),
                        ),
                      );
                    }),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              openPhotoDialog(context, _productImageList[_currentImage]);
            },
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width - 96,
              child: Container(
                  child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder_rectangle.png',
                image: _productImageList[_currentImage],
                fit: BoxFit.scaleDown,
              )),
            ),
          ),
        ],
      );
    }
  }

  Widget buildProductSliderImageSection() {
    if (_productImageList.length == 0) {
      return ShimmerHelper().buildBasicShimmer(
        height: 190.0,
      );
    } else {
      return CarouselSlider(
        carouselController: _carouselController,
        options: CarouselOptions(
            aspectRatio: 355 / 375,
            viewportFraction: 1,
            initialPage: 0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInExpo,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              print(index);
              setState(() {
                _currentImage = index;
              });
            }),
        items: _productImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        openPhotoDialog(
                            context, _productImageList[_currentImage]);
                      },
                      child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: i,
                            fit: BoxFit.fitHeight,
                          )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              _productImageList.length,
                              (index) => Container(
                                    width: 7.0,
                                    height: 7.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentImage == index
                                          ? MyTheme.font_grey
                                          : Colors.grey.withOpacity(0.2),
                                    ),
                                  ))),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      );
    }
  }

  Widget divider() {
    return Container(
      color: MyTheme.light_grey,
      height: 5,
    );
  }
}
