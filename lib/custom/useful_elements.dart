import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';

class UsefulElements {
  static backButton(context, {color = 'black'}) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
          app_language_rtl.$ ?CupertinoIcons.arrow_right :CupertinoIcons.arrow_left,
          color: color == 'white' ? Colors.white : MyTheme.dark_font_grey),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
  static backIcon(context, {color = 'black'}) {
    return Icon(
        app_language_rtl.$ ?CupertinoIcons.arrow_right :CupertinoIcons.arrow_left,
        color: color == 'white' ? Colors.white : MyTheme.dark_font_grey);
  }

  static backToMain(context, {color = 'black', go_back = true}) {
    return IconButton(
      icon: Icon(CupertinoIcons.arrow_left,
          color: color == 'white' ? Colors.white : MyTheme.dark_font_grey),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Main(
                    go_back: go_back,
                  ))),
    );
  }


  static Widget roundImageWithPlaceholder(
      {String url,
        double height = 0.0,
        double elevation = 0.0,
        double borderWidth = 0.0,
        width = 0.0,
        double paddingX = 0.0,
        double paddingY = 0.0,
        BorderRadius borderRadius =  BorderRadius.zero,
        Color backgroundColor = Colors.white,
        Color borderColor = Colors.white,
        BoxFit fit = BoxFit.cover

      }) {
    return Material(
      color: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      child:Container(
          //padding: EdgeInsets.symmetric(horizontal: paddingY, vertical: paddingX),
         // margin: EdgeInsets.symmetric(horizontal: marginY, vertical: marginX),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: borderWidth),
            color: backgroundColor,

          ),
          height: height,
          width: width,

          child:  ClipRRect(
            borderRadius: borderRadius,
            child: url != null && url.isNotEmpty
                ? FadeInImage.assetNetwork(
              placeholder: "assets/placeholder.png",
              image: url,

              imageErrorBuilder: (context, object, stackTrace) {
                return  Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      image:const DecorationImage(
                          image: AssetImage("assets/placeholder.png"),
                          fit: BoxFit.cover
                      )
                  ),
                );
              },
              height: height,
              width: width,
              fit: fit,
            )
                : Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  image:const DecorationImage(
                      image: AssetImage("assets/placeholder.png"),
                      fit: BoxFit.cover
                  )
              ),
            ),
          ),),
    );
  }

  Container customContainer(
      {double width = 0.0,
        double borderWith = 1.0,
        double height = 0.0,
        double borderRadius = 0.0,
        Color bgColor = const Color.fromRGBO(255, 255, 255, 0),
        Color borderColor = const Color.fromRGBO(255, 255, 255, 0),
        Widget child,
        double paddingX = 0.0,
        paddingY = 0.0,
        double marginX = 0.0,
        double marginY = 0.0,
        Alignment alignment = Alignment.center}) {
    return Container(
        alignment: alignment,
        padding: EdgeInsets.symmetric(horizontal: paddingY, vertical: paddingX),
        margin: EdgeInsets.symmetric(horizontal: marginY, vertical: marginX),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWith),
          color: bgColor,
        ),
        height: height,
        width: width,
        child: child);
  }


}
