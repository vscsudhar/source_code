import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/flash_deal_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_products.dart';
import 'package:active_ecommerce_flutter/repositories/flash_deal_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

class FlashDealList extends StatefulWidget {
  @override
  _FlashDealListState createState() => _FlashDealListState();
}

class _FlashDealListState extends State<FlashDealList> {
  List<CountdownTimerController> _timerControllerList = [];

  DateTime convertTimeStampToDateTime(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateToTimeStamp;
  }

  @override
  Widget build(BuildContext context) {
    print("object");
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildFlashDealList(context),
      ),
    );
  }

 Widget buildFlashDealList(context) {
    return FutureBuilder<FlashDealResponse>(
        future: FlashDealRepository().getFlashDeals(),
        builder: (context,AsyncSnapshot<FlashDealResponse> snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            //print("flashDeal error");
            //print(snapshot.error.toString());
            return Center(child: Text("Network Error!"),);
          }else
            if (snapshot.hasData) {
              //snapshot.hasData
            FlashDealResponse flashDealResponse = snapshot.data;
            return SingleChildScrollView(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 20,
                  );
                },
                itemCount: flashDealResponse.flashDeals.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return buildFlashDealListItem(flashDealResponse, index);
                },
              ),
            );
          } else {
            return buildShimmer();
          }
        });
  }

  CustomScrollView buildShimmer() {
    return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: 20,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return buildFlashDealListItemShimmer();
                  },
                ),
              )
            ],
          );
  }

  String timeText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;

    // print(txt + " " + default_length.toString());
    // print(newtxt);

    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }
    //print(newtxt);

    return newtxt;
  }

  buildFlashDealListItem(FlashDealResponse flashDealResponse, index) {
    DateTime end = convertTimeStampToDateTime(
        flashDealResponse.flashDeals[index].date); // YYYY-mm-dd
    DateTime now = DateTime.now();
    int diff = end.difference(now).inMilliseconds;
    int endTime = diff + now.millisecondsSinceEpoch;

    void onEnd() {}

    CountdownTimerController time_controller =
        CountdownTimerController(endTime: endTime, onEnd: onEnd);
    _timerControllerList.add(time_controller);

    return Container(
      // color: MyTheme.amber,
      height: 340,
      child: CountdownTimer(
        controller: _timerControllerList[index],
        widgetBuilder: (_, CurrentRemainingTime time) {
          return GestureDetector(
            onTap: () {
              if (time == null) {
                ToastComponent.showDialog(
                    AppLocalizations.of(context)
                        .flash_deal_list_screen_flash_deal_has_ended,
                    gravity: Toast.center,
                    duration: Toast.lengthLong,

                );
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FlashDealProducts(
                    flash_deal_id: flashDealResponse.flashDeals[index].id,
                    flash_deal_name: flashDealResponse.flashDeals[index].title,
                    bannerUrl: flashDealResponse.flashDeals[index].banner,
                    countdownTimerController: _timerControllerList[index],
                  );
                }));
              }
            },
            child: Stack(
              children: [
                buildFlashDealBanner( flashDealResponse, index),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: DeviceInfo(context).width,
                    height: 196,
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecorations.buildBoxDecoration_1(),
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                              child: time == null
                                  ? Text(
                                      AppLocalizations.of(context)
                                          .flash_deal_list_screen_ended,
                                      style: TextStyle(
                                          color: MyTheme.accent_color,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : buildTimerRowRow(time)),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            width: 460,
                            child: Wrap(
                              //spacing: 10,
                              runSpacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.spaceBetween,
                              alignment: WrapAlignment.start,

                              children: List.generate(
                                   flashDealResponse.flashDeals[index].products.products.length,
                                      (productIndex) {
                                return buildFlashDealsProductItem(flashDealResponse,index,productIndex);
                              }),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  buildFlashDealListItemShimmer() {
    return Container(
      // color: MyTheme.amber,
      height: 340,
      child:Stack(
        children: [
          buildFlashDealBannerShimmer(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: DeviceInfo(context).width,
              height: 196,
              margin: EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Container(
                    child: buildTimerRowRowShimmer(),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      width: 460,
                      child: Wrap(
                        //spacing: 10,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.spaceBetween,
                        alignment: WrapAlignment.start,

                        children: List.generate(
                            6,
                                (productIndex) {
                              return buildFlashDealsProductItemShimmer();
                            }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFlashDealsProductItem(flashDealResponse, flashDealIndex,productIndex) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      height: 50,
      width: 136,
      decoration: BoxDecoration(
        color: MyTheme.light_grey,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            clipBehavior: Clip.none,
            child: FadeInImage(
              placeholder: AssetImage("assets/placeholder.png"),
              image: NetworkImage(flashDealResponse.flashDeals[flashDealIndex].products.products[productIndex].image),

            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(6),bottomLeft: Radius.circular(6),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(flashDealResponse.flashDeals[flashDealIndex].products.products[productIndex].price,style: TextStyle(fontSize: 13,color: MyTheme.accent_color,fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );

  }

  Widget buildFlashDealsProductItemShimmer() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      height: 50,
      width: 136,
      decoration: BoxDecoration(
        color: MyTheme.light_grey,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(6),bottomLeft: Radius.circular(6),),
            ),
            child: ShimmerHelper().buildBasicShimmerCustomRadius(height: 50,width: 50,radius:BorderRadius.only(topLeft: Radius.circular(6),bottomLeft: Radius.circular(6),),
          ),),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child:ShimmerHelper().buildBasicShimmer(height: 15,width: 60)

          )
        ],
      ),
    );

  }

  Container buildFlashDealBanner(flashDealResponse, index) {
    return Container(
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/placeholder_rectangle.png',
        image: flashDealResponse.flashDeals[index].banner,
        fit: BoxFit.cover,
        width: DeviceInfo(context).width,
        height: 180,
      ),
    );
  }

  Widget buildFlashDealBannerShimmer() {
    return ShimmerHelper().buildBasicShimmerCustomRadius(
      width: DeviceInfo(context).width,
      height: 180,
      color: MyTheme.medium_grey_50
    );
  }

  Widget buildTimerRowRow(CurrentRemainingTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.watch_later_outlined,
            color: MyTheme.grey_153,
          ),
          SizedBox(
            width: 10,
          ),
          timerContainer(
            Text(
              timeText(time.days.toString(), default_length: 3),
              style: TextStyle(
                  color: MyTheme.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          timerContainer(
            Text(
              timeText(time.hours.toString(), default_length: 2),
              style: TextStyle(
                  color: MyTheme.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          timerContainer(
            Text(
              timeText(time.min.toString(), default_length: 2),
              style: TextStyle(
                  color: MyTheme.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          timerContainer(
            Text(
              timeText(time.sec.toString(), default_length: 2),
              style: TextStyle(
                  color: MyTheme.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Image.asset(
            "assets/flash_deal.png",
            height: 20,
            color: MyTheme.golden,
          ),
          Spacer(),
          InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    LangText(context).local.common_view_more,
                    style: TextStyle(fontSize: 10, color: MyTheme.grey_153),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  //Image.asset("assets/arrow.png",height: 10,color: MyTheme.grey_153,),
                  Icon(
                    Icons.arrow_forward_outlined,
                    size: 10,
                    color: MyTheme.grey_153,
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget buildTimerRowRowShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.watch_later_outlined,
            color: MyTheme.grey_153,
          ),
          SizedBox(
            width: 10,
          ),

            ShimmerHelper().buildBasicShimmerCustomRadius(height: 30,width: 30,radius: BorderRadius.circular(6),color: MyTheme.shimmer_base),

          SizedBox(
            width: 4,
          ),
          ShimmerHelper().buildBasicShimmerCustomRadius(height: 30,width: 30,radius: BorderRadius.circular(6),color: MyTheme.shimmer_base),
          SizedBox(
            width: 4,
          ),
          ShimmerHelper().buildBasicShimmerCustomRadius(height: 30,width: 30,radius: BorderRadius.circular(6),color: MyTheme.shimmer_base),
          SizedBox(
            width: 4,
          ),
          ShimmerHelper().buildBasicShimmerCustomRadius(height: 30,width: 30,radius: BorderRadius.circular(6),color: MyTheme.shimmer_base),
          SizedBox(
            width: 10,
          ),
          Image.asset(
            "assets/flash_deal.png",
            height: 20,
            color: MyTheme.golden,
          ),
          Spacer(),
          InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    LangText(context).local.common_view_more,
                    style: TextStyle(fontSize: 10, color: MyTheme.grey_153),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  //Image.asset("assets/arrow.png",height: 10,color: MyTheme.grey_153,),
                  Icon(
                    Icons.arrow_forward_outlined,
                    size: 10,
                    color: MyTheme.grey_153,
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget timerContainer(Widget child) {
    return Container(
      constraints: BoxConstraints(minWidth: 30, minHeight: 24),
      child: child,
      alignment: Alignment.center,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: MyTheme.accent_color,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: UsefulElements.backButton(context),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).flash_deal_list_flash_deals,
        style: TextStyle(fontSize: 16, color: MyTheme.dark_font_grey,fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
