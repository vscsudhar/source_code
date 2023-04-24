import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/order_details.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:one_context/one_context.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';

final FirebaseMessaging _fcm = FirebaseMessaging.instance;


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '0', // id
  'High Importance Notifications', // title
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class PushNotificationService {



  Future initialise() async {

    await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    String fcmToken = await _fcm.getToken();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    if (fcmToken != null) {
      // print("--fcm token--");
      // print(fcmToken);
      if (is_logged_in.$ == true) {
        // update device token
        var deviceTokenUpdateResponse =
            await ProfileRepository().getDeviceTokenUpdateResponse(fcmToken);
      }
    }

    FirebaseMessaging.onMessage.listen((event) {
      //print("onLaunch: " + event.toString());
      _showMessage(event);
      //(Map<String, dynamic> message) async => _showMessage(message);

      RemoteNotification notification = event.notification;
      AndroidNotification android = event.notification?.android;
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher

      var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);


      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android?.smallIcon,
                // other properties...
              ),
            ));
      }

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onResume: $message");
      (Map<String, dynamic> message) async => _serialiseAndNavigate(message);
    });
  }

  void _showMessage(RemoteMessage message) {
    //print("onMessage: $message");

    OneContext().showDialog(
      // barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message.notification.title),
          subtitle: Text(message.notification.body),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text('GO'),
            onPressed: () {
              if (is_logged_in.$ == false) {
                ToastComponent.showDialog("You are not logged in", gravity: Toast.top, duration: Toast.lengthLong);
                return;
              }
              //print(message);
              Navigator.of(context).pop();
              if (message.data['item_type'] == 'order') {
                OneContext().push(MaterialPageRoute(builder: (_) {
                  return OrderDetails(
                      id: int.parse(message.data['item_type_id']),
                      from_notification: true);
                }));
              }
            },
          ),
        ],
      ),
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    print(message.toString());
    if (is_logged_in.$ == false) {
      OneContext().showDialog(
        // barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: new Text("You are not logged in"),
            content: new Text("Please log in"),
            actions: <Widget>[
              FlatButton(
                child: Text('close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text('Login'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    OneContext().push(MaterialPageRoute(builder: (_) {
                      return Login();
                    }));
                  }),
            ],
          ));
      return;
    }
    if (message['data']['item_type'] == 'order') {
      OneContext().push(MaterialPageRoute(builder: (_) {
        return OrderDetails(
            id: int.parse(message['data']['item_type_id']),
            from_notification: true);
      }));
    } // If there's no view it'll just open the app on the first view    }
  }

}
