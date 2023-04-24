import 'dart:async';

import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/classified_ads/classified_product_details.dart';
import 'package:active_ecommerce_flutter/screens/digital_product/digital_product_details.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
class ClassifiedAdsCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String unit_price;
  var condition;

  ClassifiedAdsCard({Key key,this.id, this.image, this.name,this.unit_price,this.condition}) : super(key: key);

  @override
  _ClassifiedAdsCardState createState() => _ClassifiedAdsCardState();
}

class _ClassifiedAdsCardState extends State<ClassifiedAdsCard> with SingleTickerProviderStateMixin {






  @override
  void initState() {

    // Timer.periodic(Duration(milliseconds: 500), (timer) {
    //    color = timer.tick.isEven? Colors.green:Colors.grey;
    //    setState((){});
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ClassifiedAdsDetails(id: widget.id,);
        }));
      },
      child: Container(
        decoration: BoxDecorations.buildBoxDecoration_1().copyWith(

        ),
        child: Stack(
          children: [
            Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                        width: double.infinity,
                        //height: 158,
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(6), bottom: Radius.zero),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image:  widget.image,
                              fit: BoxFit.cover,
                            ))),
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Text(
                            widget.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines:widget.id.isEven?3:2,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                height: 1.2,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            widget.unit_price,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),

            Visibility(
              visible: true,
              child: Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                    decoration: BoxDecoration(
                      color:widget.condition=="new"?MyTheme.golden: MyTheme.accent_color,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6.0),
                        bottomLeft: Radius.circular(6.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x14000000),
                          offset: Offset(-1, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      widget.condition??"",
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                        height: 1.8,
                      ),
                      textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                      softWrap: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
