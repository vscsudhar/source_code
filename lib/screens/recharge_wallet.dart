/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/stripe_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/paypal_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/razorpay_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/paystack_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/iyzico_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/bkash_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/nagad_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/sslcommerz_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/flutterwave_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/paytm_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';

import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RechargeWallet extends StatefulWidget {
  double amount;

  RechargeWallet({Key key, this.amount}) : super(key: key);

  @override
  _RechargeWalletState createState() => _RechargeWalletState();
}

class _RechargeWalletState extends State<RechargeWallet> {
  var _selected_payment_method = "";
  var _selected_payment_method_key = "";

  ScrollController _mainScrollController = ScrollController();
  var _paymentTypeList = [];
  bool _isInitial = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/

    fetchAll();
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchAll() {
    fetchList();
  }

  fetchList() async {
    var paymentTypeResponseList =
        await PaymentRepository().getPaymentResponseList(mode: "wallet");
    _paymentTypeList.addAll(paymentTypeResponseList);
    if (_paymentTypeList.length > 0) {
      _selected_payment_method = _paymentTypeList[0].payment_type;
      _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
    }
    _isInitial = false;
    setState(() {});
  }

  reset() {
    _paymentTypeList.clear();
    _isInitial = true;
    _selected_payment_method = "";
    _selected_payment_method_key = "";
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  onPressRechargeWallet() {
    print("grant total value");
    print(widget.amount);

    if (_selected_payment_method == "") {
      ToastComponent.showDialog(AppLocalizations.of(context).common_payment_choice_warning, gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_selected_payment_method == "stripe_payment") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StripeScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "paypal_payment") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaypalScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "razorpay") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RazorpayScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "paystack") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaystackScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "iyzico") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return IyzicoScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "bkash") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BkashScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "nagad") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NagadScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "sslcommerz_payment") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SslCommerzScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "flutterwave") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FlutterwaveScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "paytm") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_nothing_to_pay, gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaytmScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    }
  }

  onPaymentMethodItemTap(index) {
    if (_selected_payment_method != _paymentTypeList[index].payment_type) {
      setState(() {
        _selected_payment_method = _paymentTypeList[index].payment_type;
        _selected_payment_method_key = _paymentTypeList[index].payment_type_key;
      });
    }

    //print(_selected_payment_method);
    //print(_selected_payment_method_key);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          bottomNavigationBar: buildBottomAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: CustomScrollView(
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildPaymentMethodList(),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ],
          )),
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
        AppLocalizations.of(context).recharge_wallet_screen_recharge_wallet,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildPaymentMethodList() {
    if (_isInitial && _paymentTypeList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_paymentTypeList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _paymentTypeList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildPaymentMethodItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _paymentTypeList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).common_no_payment_method_added,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildPaymentMethodItemCard(index) {
    return GestureDetector(
      onTap: () {
        onPaymentMethodItemTap(index);
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: _selected_payment_method ==
                      _paymentTypeList[index].payment_type
                  ? BorderSide(color: MyTheme.accent_color, width: 2.0)
                  : BorderSide(color: MyTheme.light_grey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 100,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              /*Image.asset(
                          _paymentTypeList[index].image,
                          fit: BoxFit.fitWidth,
                        ),*/
                              FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: _paymentTypeList[index].image,
                            fit: BoxFit.fitWidth,
                          ))),
                  Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            _paymentTypeList[index].title,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          app_language_rtl.$
              ? Positioned(
                  left: 16,
                  top: 16,
                  child: buildPaymentMethodCheckContainer(
                      _selected_payment_method ==
                          _paymentTypeList[index].payment_type),
                )
              : Positioned(
                  right: 16,
                  top: 16,
                  child: buildPaymentMethodCheckContainer(
                      _selected_payment_method ==
                          _paymentTypeList[index].payment_type),
                )
        ],
      ),
    );
  }

  Container buildPaymentMethodCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(FontAwesome.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: MyTheme.accent_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                AppLocalizations.of(context).recharge_wallet_screen_recharge_wallet,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressRechargeWallet();
              },
            )
          ],
        ),
      ),
    );
  }
}*/
