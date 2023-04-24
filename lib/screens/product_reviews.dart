import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:expandable/expandable.dart';
import 'package:active_ecommerce_flutter/repositories/review_repositories.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductReviews extends StatefulWidget {
  int id;

  ProductReviews({Key key, this.id}) : super(key: key);

  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  final TextEditingController _myReviewTextController = TextEditingController();
  ScrollController _xcrollController = ScrollController();
  ScrollController scrollController = ScrollController();

  double _my_rating = 0.0;

  List<dynamic> _reviewList = [];
  bool _isInitial = true;
  int _page = 1;
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

  fetchData() async {
    var reviewResponse = await ReviewRepository().getReviewResponse(
      widget.id,
      page: _page,
    );
    _reviewList.addAll(reviewResponse.reviews);
    _isInitial = false;
    _totalData = reviewResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _reviewList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    _my_rating = 0.0;
    _myReviewTextController.text = "";
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onTapReviewSubmit(context) async {
    if (is_logged_in.$ == false) {
      ToastComponent.showDialog("You need to login to give a review", gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    //return;
    var myReviewText = _myReviewTextController.text.toString();
    //print(chatText);
    if (myReviewText == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .product_reviews_screen_review_empty_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (_my_rating < 1.0) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).product_reviews_screen_star_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    var reviewSubmitResponse = await ReviewRepository()
        .getReviewSubmitResponse(widget.id, _my_rating.toInt(), myReviewText);

    if (reviewSubmitResponse.result == false) {
      ToastComponent.showDialog(reviewSubmitResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(reviewSubmitResponse.message, gravity: Toast.center, duration: Toast.lengthLong);

    reset();
    fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _xcrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: CustomScrollView(
                  controller: _xcrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildProductReviewsList(),
                        ),
                        Container(
                          height: 120,
                        )
                      ]),
                    )
                  ],
                ),
              ), //original

              Align(
                alignment: Alignment.bottomCenter,
                child: buildBottomBar(context),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: buildLoadingContainer()),
            ],
          )),
    );
  }

  buildBottomBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: new BoxDecoration(color: Colors.white54.withOpacity(0.6)),
          height: 120,
          //color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
            child: buildGiveReviewSection(context),
          ),
        ),
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
        AppLocalizations.of(context).product_reviews_screen_reviews,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildProductReviewsList() {
    if (_isInitial && _reviewList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 10, item_height: 75.0));
    } else if (_reviewList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          controller: scrollController,
          itemCount: _reviewList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: buildProductReviewsItem(index),
            );
          },
        ),
      );
    } else if (_totalData == 0) {
      return Container(
        height: 300,
        child: Center(
            child: Text(AppLocalizations.of(context)
                .product_reviews_screen_no_reviews_yet)),
      );
    } else {
      return Container(); // should never be happening
    }
  }

  buildProductReviewsItem(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                    color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                //shape: BoxShape.rectangle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image:  _reviewList[index].avatar,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 180,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _reviewList[index].user_name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              height: 1.6,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            _reviewList[index].time,
                            style: TextStyle(color: MyTheme.medium_grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Padding(
                padding:
                    const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 16.0),
                child: Container(
                  child: RatingBar(
                    itemSize: 12.0,
                    ignoreGestures: true,
                    initialRating: _reviewList[index].rating,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: Icon(FontAwesome.star, color: Colors.amber),
                      half: Icon(FontAwesome.star_half, color: Colors.amber),
                      empty: Icon(FontAwesome.star,
                          color: Color.fromRGBO(224, 224, 225, 1)),
                    ),
                    itemPadding: EdgeInsets.only(right: 1.0),
                    onRatingUpdate: (rating) {
                      //print(rating);
                    },
                  ),
                ))
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 56.0),
            child: buildExpandableDescription(index),
          )
        ],
      ),
    );
  }

  ExpandableNotifier buildExpandableDescription(index) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: Container(
                height: _reviewList[index].comment.length > 100 ? 32 : 16,
                child: Text(_reviewList[index].comment,
                    style: TextStyle(color: MyTheme.font_grey))),
            expanded: Container(
                child: Text(_reviewList[index].comment,
                    style: TextStyle(color: MyTheme.font_grey))),
          ),
          _reviewList[index].comment.length > 100
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Builder(
                      builder: (context) {
                        var controller = ExpandableController.of(context);
                        return FlatButton(
                          child: Text(
                            !controller.expanded ? AppLocalizations.of(context).common_view_more : AppLocalizations.of(context).common_show_less,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 11),
                          ),
                          onPressed: () {
                            controller.toggle();
                          },
                        );
                      },
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _reviewList.length
            ? AppLocalizations.of(context).product_reviews_screen_no_more_reviews
            : AppLocalizations.of(context).product_reviews_screen_loading_more_reviews),
      ),
    );
  }

  buildGiveReviewSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: RatingBar.builder(
            itemSize: 20.0,
            initialRating: _my_rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            glowColor: Colors.amber,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) {
              return Icon(FontAwesome.star, color: Colors.amber);
            },
            onRatingUpdate: (rating) {
              setState(() {
                _my_rating = rating;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 40,
              width: (MediaQuery.of(context).size.width - 32) * (4 / 5),
              child: TextField(
                autofocus: false,
                maxLines: null,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(125),
                ],
                controller: _myReviewTextController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(251, 251, 251, 1),
                    hintText: AppLocalizations.of(context).product_reviews_screen_type_your_review_here,
                    hintStyle: TextStyle(
                        fontSize: 14.0, color: MyTheme.textfield_grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyTheme.medium_grey, width: 0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  onTapReviewSubmit(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    color: MyTheme.accent_color,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                        color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                    //shape: BoxShape.rectangle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
