import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/enum_classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:active_ecommerce_flutter/repositories/order_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/repositories/refund_request_repository.dart';
import 'package:active_ecommerce_flutter/screens/refund_request.dart';
import 'dart:async';
import 'package:active_ecommerce_flutter/screens/checkout.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetails extends StatefulWidget {
  int id;
  final bool from_notification;
  bool go_back;

  OrderDetails(
      {Key key, this.id, this.from_notification = false, this.go_back = true})
      : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ScrollController _mainScrollController = ScrollController();
  var _steps = [
    'pending',
    'confirmed',
    'on_delivery',
    'picked_up',
    'on_the_way',
    'delivered'
  ];

  TextEditingController _refundReasonController = TextEditingController();
  bool _showReasonWarning = false;

  //init
  int _stepIndex = 0;
  var _orderDetails = null;
  List<dynamic> _orderedItemList = [];
  bool _orderItemsInit = false;

  @override
  void initState() {
    fetchAll();
    super.initState();

    print(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchAll() {
    fetchOrderDetails();
    fetchOrderedItems();
  }

  fetchOrderDetails() async {
    var orderDetailsResponse =
        await OrderRepository().getOrderDetails(id: widget.id);

    if (orderDetailsResponse.detailed_orders.length > 0) {
      _orderDetails = orderDetailsResponse.detailed_orders[0];
      setStepIndex(_orderDetails.delivery_status);
    }

    setState(() {});
  }

  setStepIndex(key) {
    _stepIndex = _steps.indexOf(key);
    setState(() {});
  }

  fetchOrderedItems() async {
    var orderItemResponse =
        await OrderRepository().getOrderItems(id: widget.id);
    _orderedItemList.addAll(orderItemResponse.ordered_items);
    _orderItemsInit = true;

    setState(() {});
  }

  reset() {
    _stepIndex = 0;
    _orderDetails = null;
    _orderedItemList.clear();
    _orderItemsInit = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }


  onPressOfflinePaymentButton() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Checkout(
        order_id: widget.id,
        title: AppLocalizations.of(context).checkout_screen_checkout,
        list: "offline",
        paymentFor: PaymentFor.ManualPayment,
        //offLinePaymentFor: OffLinePaymentFor.Order,
        rechargeAmount:double.parse(_orderDetails.plane_grand_total.toString()),
      );
    })).then((value) {
      onPopped(value);
    });
  }

  onTapAskRefund(item_id, item_name, order_code) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                                AppLocalizations.of(context)
                                    .order_details_screen_refund_product_name,
                                style: TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12)),
                            Container(
                              width: 225,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(item_name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: MyTheme.font_grey,
                                        fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                                AppLocalizations.of(context)
                                    .order_details_screen_refund_order_code,
                                style: TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12)),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(order_code,
                                  style: TextStyle(
                                      color: MyTheme.font_grey, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                                "${AppLocalizations.of(context).order_details_screen_refund_reason} *",
                                style: TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12)),
                            _showReasonWarning
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .order_details_screen_refund_reason_empty_warning,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _refundReasonController,
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .order_details_screen_refund_enter_reason,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 8.0, top: 16.0, bottom: 16.0)),
                          ),
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
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FlatButton(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context)
                              .common_close_in_all_capital,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          _refundReasonController.clear();
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: FlatButton(
                        minWidth: 75,
                        height: 30,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context).common_submit,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onPressSubmitRefund(item_id, setState);
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  shoWReasonWarning(setState) {
    setState(() {
      _showReasonWarning = true;
    });
    Timer timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _showReasonWarning = false;
      });
    });
  }

  onPressSubmitRefund(item_id, setState) async {
    var reason = _refundReasonController.text.toString();

    if (reason == "") {
      shoWReasonWarning(setState);
      return;
    }

    var refundRequestSendResponse = await RefundRequestRepository()
        .getRefundRequestSendResponse(id: item_id, reason: reason);

    if (refundRequestSendResponse.result == false) {
      ToastComponent.showDialog(refundRequestSendResponse.message, gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    _refundReasonController.clear();

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        refundRequestSendResponse.message,
        style: TextStyle(color: MyTheme.font_grey),
      ),
      backgroundColor: MyTheme.soft_accent_color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: AppLocalizations.of(context)
            .order_details_screen_refund_snackbar_show_request_list,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RefundRequest();
          })).then((value) {
            onPopped(value);
          });
        },
        textColor: MyTheme.accent_color,
        disabledTextColor: Colors.grey,
      ),
    ));

    reset();
    fetchAll();
    setState(() {});
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.from_notification || widget.go_back == false) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Main();
          }));
        }
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 20.0),
                      child: _orderDetails != null
                          ? buildTimeLineTiles()
                          : buildTimeLineShimmer()),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(left:18.0,right:18.0,bottom: 20.0),
                    child: _orderDetails != null
                        ? buildOrderDetailsTopCard()
                        : ShimmerHelper().buildBasicShimmer(height: 150.0),
                  ),
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_ordered_product,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                     padding: const EdgeInsets.only(left:18.0,right:18.0,top: 14.0),
                      child: _orderedItemList.length == 0 && _orderItemsInit
                          ? ShimmerHelper().buildBasicShimmer(height: 100.0)
                          : (_orderedItemList.length > 0
                              ? buildOrderdProductList()
                              : Container(
                                  height: 100,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .order_details_screen_ordered_product,
                                    style: TextStyle(color: MyTheme.font_grey),
                                  ),
                                )))
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 75,
                        ),
                        buildBottomSection()
                      ],
                    ),
                  )
                ])),
                SliverList(
                    delegate:
                        SliverChildListDelegate([buildPaymentButtonSection()]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildBottomSection() {
    return Expanded(
      child: _orderDetails != null
          ? Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .order_details_screen_sub_total,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.subtotal,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .order_details_screen_tax,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.tax,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .order_details_screen_shipping_cost,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.shipping_cost,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .order_details_screen_discount,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.coupon_discount,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .order_details_screen_grand_total,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails.grand_total,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            )
          : ShimmerHelper().buildBasicShimmer(height: 100.0),
    );
  }

  buildTimeLineShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 20, width: 250.0),
        )
      ],
    );
  }

  buildTimeLineTiles() {
    print(_orderDetails.delivery_status);
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isFirst: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _orderDetails.delivery_status == "pending" ? 36 : 30,
                    height:
                        _orderDetails.delivery_status == "pending" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.redAccent, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.list_alt,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_timeline_tile_order_placed,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 0 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 0
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            afterLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails.delivery_status == "confirmed" ? 36 : 30,
                    height:
                        _orderDetails.delivery_status == "confirmed" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.thumb_up_sharp,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_timeline_tile_confirmed,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 1 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 1
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _orderDetails.delivery_status == "on_delivery"
                        ? 36
                        : 30,
                    height: _orderDetails.delivery_status == "on_delivery"
                        ? 36
                        : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.amber, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_timeline_tile_on_delivery,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 2 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 2
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isLast: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails.delivery_status == "delivered" ? 36 : 30,
                    height:
                        _orderDetails.delivery_status == "delivered" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.purple, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.purple,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_timeline_tile_delivered,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 5 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 5
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
        ],
      ),
    );
  }

   buildOrderDetailsTopCard() {
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Order Code",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Shipping Method",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails.code,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.shipping_type_string,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Order Date",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Payment Method",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails.date,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.payment_type,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Payment Status",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Delivery Status",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      _orderDetails.payment_status_string,
                      style: TextStyle(
                        color: MyTheme.grey_153,
                      ),
                    ),
                  ),
                  buildPaymentStatusCheckContainer(
                      _orderDetails.payment_status),
                  Spacer(),
                  Text(
                    _orderDetails.delivery_status_string,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  _orderDetails.shipping_address != null
                      ? "Shipping Address"
                      : "Pickup Point",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Total Amount",
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - (32.0)) / 2,
                    // (total_screen_width - padding)/2
                    child: _orderDetails.shipping_address != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _orderDetails.shipping_address.name != null
                                  ? Text(
                                      "${AppLocalizations.of(context).order_details_screen_name}: ${_orderDetails.shipping_address.name}",
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: MyTheme.grey_153,
                                      ),
                                    )
                                  : Container(),
                              _orderDetails.shipping_address.email != null
                                  ? Text(
                                      "${AppLocalizations.of(context).order_details_screen_email}: ${_orderDetails.shipping_address.email}",
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: MyTheme.grey_153,
                                      ),
                                    )
                                  : Container(),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_address}: ${_orderDetails.shipping_address.address}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_city}: ${_orderDetails.shipping_address.city}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_country}: ${_orderDetails.shipping_address.country}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_state}: ${_orderDetails.shipping_address.state}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_phone}: ${_orderDetails.shipping_address.phone}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_postal_code}: ${_orderDetails.shipping_address.postal_code}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _orderDetails.pickupPoint.name != null
                                  ? Text(
                                      "${AppLocalizations.of(context).order_details_screen_name}: ${_orderDetails.pickupPoint.name}",
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: MyTheme.grey_153,
                                      ),
                                    )
                                  : Container(),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_address}: ${_orderDetails.pickupPoint.address}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).address_screen_phone}: ${_orderDetails.pickupPoint.phone}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              ),
                            ],
                          ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.grand_total,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

   buildOrderedProductItemsCard(index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _orderedItemList[index].product_name,
                maxLines: 2,
                style: TextStyle(
                  color: MyTheme.font_grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderedItemList[index].quantity.toString() + " x ",
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  _orderedItemList[index].variation != "" &&
                          _orderedItemList[index].variation != null
                      ? Text(
                          _orderedItemList[index].variation,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          "item",
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                  Spacer(),
                  Text(
                    _orderedItemList[index].price,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            _orderedItemList[index].refund_section &&
                    _orderedItemList[index].refund_button
                ? InkWell(
                    onTap: () {
                      onTapAskRefund(
                          _orderedItemList[index].id,
                          _orderedItemList[index].product_name,
                          _orderDetails.code);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .order_details_screen_ask_for_refund,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Icon(
                              FontAwesome.rotate_left,
                              color: MyTheme.accent_color,
                              size: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            _orderedItemList[index].refund_section &&
                    _orderedItemList[index].refund_label != ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .order_details_screen_refund_status,
                            style: TextStyle(color: MyTheme.font_grey),
                          ),
                          Text(
                            _orderedItemList[index].refund_label,
                            style: TextStyle(
                                color: getRefundRequestLabelColor(
                                    _orderedItemList[index]
                                        .refund_request_status)),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  getRefundRequestLabelColor(status) {
    if (status == 0) {
      return Colors.blue;
    } else if (status == 2) {
      return Colors.orange;
    } else if (status == 1) {
      return Colors.green;
    } else {
      return MyTheme.font_grey;
    }
  }

  buildOrderdProductList() {
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
              color: MyTheme.medium_grey
          ),
          itemCount: _orderedItemList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildOrderedProductItemsCard(index);
          },
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
            onPressed: () {
              if (widget.from_notification || widget.go_back == false) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Main();
                }));
              } else {
                return Navigator.of(context).pop();
              }
            }),
      ),
      title: Text(
        AppLocalizations.of(context).order_details_screen_order_details,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildPaymentButtonSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _orderDetails != null && _orderDetails.manually_payable
              ? FlatButton(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    AppLocalizations.of(context)
                        .order_details_screen_make_offline_payment,
                    style: TextStyle(color: MyTheme.font_grey),
                  ),
                  onPressed: () {
                    onPressOfflinePaymentButton();
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Container buildPaymentStatusCheckContainer(String payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: payment_status == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(
            payment_status == "paid" ? FontAwesome.check : FontAwesome.times,
            color: Colors.white,
            size: 10),
      ),
    );
  }
}
