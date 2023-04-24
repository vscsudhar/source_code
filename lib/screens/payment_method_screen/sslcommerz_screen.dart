import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SslCommerzScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String payment_method_key;
  var package_id;
  SslCommerzScreen(
      {Key key,
      this.amount = 0.00,
      this.payment_type = "",
        this.package_id="0",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _SslCommerzScreenState createState() => _SslCommerzScreenState();
}

class _SslCommerzScreenState extends State<SslCommerzScreen> {
  int _combined_order_id = 0;
  bool _order_init = false;

  String _initial_url = "";
  bool _initial_url_fetched = false;

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.payment_type == "cart_payment") {
      createOrder();
    }

    if (widget.payment_type != "cart_payment") {
      // on cart payment need proper order id
      getSetInitialUrl();
    }
  }

  createOrder() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponse( widget.payment_method_key);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.of(context).pop();
      return;
    }

    _combined_order_id = orderCreateResponse.combined_order_id;
    _order_init = true;
    setState(() {});

    getSetInitialUrl();
  }

  getSetInitialUrl() async {
    var sslcommerzUrlResponse = await PaymentRepository().getSslcommerzBeginResponse(
        widget.payment_type, _combined_order_id,widget.package_id ,widget.amount);

    if (sslcommerzUrlResponse.result == false) {
      ToastComponent.showDialog(sslcommerzUrlResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.of(context).pop();
      return;
    }

    _initial_url = sslcommerzUrlResponse.url;
    _initial_url_fetched = true;


    setState(() {});

    //print(_initial_url);
    //print(_initial_url_fetched);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  void getData() {
    _webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      // var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(data);
      //print(data.toString());
      if (responseJSON["result"] == false) {
        Toast.show(responseJSON["message"],
            duration: Toast.lengthLong, gravity: Toast.center);
        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        Toast.show(responseJSON["message"],
            duration: Toast.lengthLong, gravity: Toast.center);
        if (widget.payment_type == "cart_payment") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OrderList(from_checkout: true);
          }));
        } else if (widget.payment_type == "wallet_payment") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Wallet(from_recharge: true);
          }));
        }
      }
    });
  }



  buildBody() {
/*    String initial_url =
        "${AppConfig.BASE_URL}/sslcommerz/begin?payment_type=${widget.payment_type}&combined_order_id=${_combined_order_id}&amount=${widget.amount}&user_id=${user_id.$}";*/

    //print("init url");
    //print(initial_url);

    if (_order_init == false &&
        _combined_order_id == 0 &&
        widget.payment_type == "cart_payment") {
      return Container(
        child: Center(
          child: Text(AppLocalizations.of(context).common_creating_order),
        ),
      );
    }else if (_initial_url_fetched == false) {
      return Container(
        child: Center(
          child: Text(AppLocalizations.of(context).sslcommerz_screen_fetching_sslcommerz_url),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController.loadUrl(_initial_url);
            },
            onWebResourceError: (error) {},
            onPageFinished: (page) {
              //print(page.toString());

              if (page.contains("/sslcommerz/success")) {
                getData();
              } else if (page.contains("/sslcommerz/cancel") || page.contains("/sslcommerz/fail")) {
                ToastComponent.showDialog("Payment cancelled or failed", gravity: Toast.center, duration: Toast.lengthLong);
                Navigator.of(context).pop();
                return;
              }
            },
          ),
        ),
      );
    }
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
        AppLocalizations.of(context).sslcommerz_screen_pay_with_sslcommerz  ,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
