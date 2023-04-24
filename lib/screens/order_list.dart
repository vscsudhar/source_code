import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/screens/order_details.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_ecommerce_flutter/repositories/order_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_context/one_context.dart';


class PaymentStatus {
  String option_key;
  String name;

  PaymentStatus(this.option_key, this.name);

  static List<PaymentStatus> getPaymentStatusList() {
    return <PaymentStatus>[
      PaymentStatus('', AppLocalizations.of(OneContext().context).order_list_screen_all_payments),
      PaymentStatus('paid', AppLocalizations.of(OneContext().context).order_list_screen_paid),
      PaymentStatus('unpaid', AppLocalizations.of(OneContext().context).order_list_screen_unpaid),
    ];
  }
}

class DeliveryStatus {
  String option_key;
  String name;

  DeliveryStatus(this.option_key, this.name);

  static List<DeliveryStatus> getDeliveryStatusList() {
    return <DeliveryStatus>[
      DeliveryStatus('', AppLocalizations.of(OneContext().context).order_list_screen_all_deliveries),
      DeliveryStatus('confirmed', AppLocalizations.of(OneContext().context).order_list_screen_confirmed),
      DeliveryStatus('on_delivery', AppLocalizations.of(OneContext().context).order_list_screen_on_delivery),
      DeliveryStatus('delivered', AppLocalizations.of(OneContext().context).order_list_screen_delivered),
    ];
  }
}

class OrderList extends StatefulWidget {
  OrderList({Key key, this.from_checkout = false}) : super(key: key);
  final bool from_checkout;

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();

  List<PaymentStatus> _paymentStatusList = PaymentStatus.getPaymentStatusList();
  List<DeliveryStatus> _deliveryStatusList =
      DeliveryStatus.getDeliveryStatusList();

  PaymentStatus _selectedPaymentStatus;
  DeliveryStatus _selectedDeliveryStatus;

  List<DropdownMenuItem<PaymentStatus>> _dropdownPaymentStatusItems;
  List<DropdownMenuItem<DeliveryStatus>> _dropdownDeliveryStatusItems;

  //------------------------------------
  List<dynamic> _orderList = [];
  bool _isInitial = true;
  int _page = 1;
  int _totalData = 0;
  bool _showLoadingContainer = false;
  String _defaultPaymentStatusKey = '';
  String _defaultDeliveryStatusKey = '';

  @override
  void initState() {
    init();
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

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  init() {
    _dropdownPaymentStatusItems =
        buildDropdownPaymentStatusItems(_paymentStatusList);

    _dropdownDeliveryStatusItems =
        buildDropdownDeliveryStatusItems(_deliveryStatusList);

    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }
  }

  reset() {
    _orderList.clear();
    _isInitial = true;
    _page = 1;
    _totalData = 0;
    _showLoadingContainer = false;
  }

  resetFilterKeys() {
    _defaultPaymentStatusKey = '';
    _defaultDeliveryStatusKey = '';

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    resetFilterKeys();
    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }
    setState(() {});
    fetchData();
  }

  fetchData() async {
    var orderResponse = await OrderRepository().getOrderList(
        page: _page,
        payment_status: _selectedPaymentStatus.option_key,
        delivery_status: _selectedDeliveryStatus.option_key);
    //print("or:"+orderResponse.toJson().toString());
    _orderList.addAll(orderResponse.orders);
    _isInitial = false;
    _totalData = orderResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  List<DropdownMenuItem<PaymentStatus>> buildDropdownPaymentStatusItems(
      List _paymentStatusList) {
    List<DropdownMenuItem<PaymentStatus>> items = List();
    for (PaymentStatus item in _paymentStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<DeliveryStatus>> buildDropdownDeliveryStatusItems(
      List _deliveryStatusList) {
    List<DropdownMenuItem<DeliveryStatus>> items = List();
    for (DeliveryStatus item in _deliveryStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (widget.from_checkout) {
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
              body: Stack(
                children: [
                  buildOrderListList(),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: buildLoadingContainer())
                ],
              )),
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _orderList.length
            ? AppLocalizations.of(context).order_list_screen_no_more_orders
            : AppLocalizations.of(context).order_list_screen_loading_more_orders),
      ),
    );
  }

  buildBottomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecorations.buildBoxDecoration_1(),
            padding: EdgeInsets.symmetric(horizontal: 14),
            height: 36,
            width: MediaQuery.of(context).size.width * .4,
            child: new DropdownButton<PaymentStatus>(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                AppLocalizations.of(context).order_list_screen_all_payments,
                style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 12,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedPaymentStatus,
              items: _dropdownPaymentStatusItems,
              onChanged: (PaymentStatus selectedFilter) {
                setState(() {
                  _selectedPaymentStatus = selectedFilter;
                });
                reset();
                fetchData();
              },
            ),
          ),

          Container(
            decoration: BoxDecorations.buildBoxDecoration_1(),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            width: MediaQuery.of(context).size.width * .4,
            child: new DropdownButton<DeliveryStatus>(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                AppLocalizations.of(context).order_list_screen_all_deliveries,
                style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 12,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedDeliveryStatus,
              items: _dropdownDeliveryStatusItems,
              onChanged: (DeliveryStatus selectedFilter) {
                setState(() {
                  _selectedDeliveryStatus = selectedFilter;
                });
                reset();
                fetchData();
              },
            ),
          ),
        ],
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(104.0),
      child: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            new Container(),
          ],
          elevation: 0.0,
          titleSpacing: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Column(
              children: [
                Padding(
                  padding: MediaQuery.of(context).viewPadding.top >
                          30 //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                      ? const EdgeInsets.only(top: 36.0)
                      : const EdgeInsets.only(top: 14.0),
                  child: buildTopAppBarContainer(),
                ),
                buildBottomAppBar(context)
              ],
            ),
          )),
    );
  }

  Container buildTopAppBarContainer() {
    return Container(
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              padding: EdgeInsets.zero,
              icon: UsefulElements.backIcon(context),
              onPressed: () {
                if (widget.from_checkout) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Main();
                  }));
                } else {
                  return Navigator.of(context).pop();
                }
              },
            ),
          ),
          Text(
            AppLocalizations.of(context).profile_screen_purchase_history,
            style: TextStyle(fontSize: 16, color: MyTheme.dark_font_grey,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  buildOrderListList() {
    if (_isInitial && _orderList.length == 0) {
      return SingleChildScrollView(
          child: ListView.builder(
        controller: _scrollController,
        itemCount: 10,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
            child: Shimmer.fromColors(
              baseColor: MyTheme.shimmer_base,
              highlightColor: MyTheme.shimmer_highlighted,
              child: Container(
                height: 75,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          );
        },
      ));
    } else if (_orderList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 14,
            ),
            padding: const EdgeInsets.only(left: 18,right:18,top:0,bottom: 0),
            itemCount: _orderList.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return OrderDetails(
                      id: _orderList[index].id,
                    );
                  }));
                },
                child: buildOrderListItemCard(index),
              );
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(child: Text(AppLocalizations.of(context).common_no_data_available));
    } else {
      return Container(); // should never be happening
    }
  }

   buildOrderListItemCard(int index) {
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _orderList[index].code,
                style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [

                  Text(_orderList[index].date,
                      style: TextStyle(color: MyTheme.dark_font_grey, fontSize: 12)),
                  Spacer(),
                  Text(
                    _orderList[index].grand_total,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [

                  Text(
                    "${AppLocalizations.of(context).order_list_screen_payment_status} - ",
                    style: TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                  ),
                  Text(
                    _orderList[index].payment_status_string,
                    style: TextStyle(color:_orderList[index].payment_status=="paid"? Colors.green:Colors.red, fontSize: 12,fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "${AppLocalizations.of(context).order_list_screen_delivery_status} -",
                  style: TextStyle(color: MyTheme.dark_font_grey, fontSize: 12),
                ),
                Text(
                  _orderList[index].delivery_status_string,
                  style: TextStyle(color: MyTheme.dark_font_grey, fontSize: 12,fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
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
