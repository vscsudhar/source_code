import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/*

    Not using this as One context is used

    https://stackoverflow.com/questions/66139776/get-the-global-context-in-flutter/66140195

    Create the class. Here it named as NavigationService

    class NavigationService {
    static GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

    }

    Set the navigatorKey property of MaterialApp in the main.dart

    Widget build(BuildContext context) {
      return MaterialApp(
        navigatorKey: NavigationService.navigatorKey, // set property
      )
    }

    Great! Now you can use anywhere you want e.g.

    print("---print context:
      ${NavigationService.navigatorKey.currentContext}");


  */
}
