import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/enum_classes.dart';
import 'package:active_ecommerce_flutter/custom/fade_network_image.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/scroll_to_hide_widget.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/carriers_response.dart';
import 'package:active_ecommerce_flutter/data_model/delivery_info_response.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/repositories/pickup_points_repository.dart';
import 'package:active_ecommerce_flutter/repositories/shipping_repository.dart';
import 'package:active_ecommerce_flutter/screens/checkout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShippingInfo extends StatefulWidget {
  int owner_id;

  ShippingInfo({Key key, this.owner_id}) : super(key: key);

  @override
  _ShippingInfoState createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  ScrollController _mainScrollController = ScrollController();

  List<SellerWithShipping> _sellerWiseShippingOption = [];

  List<DeliveryInfoResponse> _deliveryInfoList = [];


  String _shipping_cost_string = ". . .";

  // Boolean variables
  bool _isFetchDeliveryInfo = false;




  //double variables
  double mWidth = 0;
  double mHeight = 0;

  fetchAll() {
    getDeliveryInfo();
  }

  getDeliveryInfo() async {
    _deliveryInfoList = await ShippingRepository().getDeliveryInfo();
    _isFetchDeliveryInfo = true;
    _deliveryInfoList.forEach((element) {
      var shippingOption = carrier_base_shipping.$
          ? ShippingOption.Carrier
          : ShippingOption.HomeDelivery;
      var shippingId = carrier_base_shipping.$
          ? element.carriers.data.first.id
          : 0;
      _sellerWiseShippingOption.add(
          new SellerWithShipping(element.ownerId, shippingOption, shippingId));
    });
    getSetShippingCost();
    setState(() {});
  }


  /*fetchSellers() async {
    var cartResponseList =
    await CartRepository().getCartResponseList(user_id.$);

    if (cartResponseList != null && cartResponseList.length > 0) {
      _deliveryInfoList = cartResponseList;
      
    }
    _deliveryInfoList.forEach((element) { 
      _sellerWiseShipping.add(new SellerWithShipping(element.owner_id,
          carrier_base_shipping.$?ShippingOption.Carrier:ShippingOption.HomeDelivery,0));
    });
    _isSellersFetch = true;
    setState(() {});

  }*/
  // fetchPickupPoints() async {
  //   var pickupPointsResponse =
  //       await PickupPointRepository().getPickupPointListResponse();
  //   _pickupPointList.addAll(pickupPointsResponse.data);
  //   setState(() {});
  // }
/*
  fetchHomeDeliveryAddress() async {
    var addressResponse = await AddressRepository().getHomeDeliveryAddress();
    _shippingAddressList.addAll(addressResponse.addresses);
    _homeDeliveryAddressFetch = true;
    setState(() {});
    // getSetShippingCost();
  }*/

  // _getCarriers() async {
  //   var carriers = await ShippingRepository().getCarrierList();
  //   _carrierList.addAll(carriers.data);
  //   _fetchCarrier = true;
  //   setState(() {});
  // }

  getSetShippingCost() async {
    var shippingCostResponse;
    shippingCostResponse =
    await AddressRepository().getShippingCostResponse(
        shipping_type: _sellerWiseShippingOption);

    if (shippingCostResponse.result == true) {
      _shipping_cost_string = shippingCostResponse.value_string;
    } else {
      _shipping_cost_string = "0.0";
    }
    setState(() {});
  }


  resetData(){
    clearData();
    fetchAll();
  }

  clearData() {
    _deliveryInfoList.clear();
    _sellerWiseShippingOption.clear();
    _shipping_cost_string = ". . .";
    _shipping_cost_string = ". . .";
    _isFetchDeliveryInfo = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    clearData();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
    resetData();
  }

  afterAddingAnAddress() {
    resetData();
  }

  onPickUpPointSwitch() async {
    _shipping_cost_string = ". . .";
    setState(() {});
  }

  changeShippingOption(ShippingOption option, index) {

    if (option.index == 1) {
      if(_deliveryInfoList.first.pickupPoints.isNotEmpty)
      _sellerWiseShippingOption[index].shippingId =
          _deliveryInfoList.first.pickupPoints.first.id;
    }
    if (option.index == 2) {
      if(_deliveryInfoList.first.carriers.data.isNotEmpty)
      _sellerWiseShippingOption[index].shippingId =
          _deliveryInfoList.first.carriers.data.first.id;
    }
    _sellerWiseShippingOption[index].shippingOption = option;
    getSetShippingCost();

    setState(() {});
  }

  onPressProceed(context) async {
    var shippingCostResponse;


    // print(jsonEncode(_sellerWiseShipping));


    var _sellerWiseShippingOptionValidation =  _sellerWiseShippingOption.where((element) {
      if(element.shippingId == 0){
        return true;
      }
      return false;
    });
    // print(jsonEncode(_sellerWiseShipping));

    if(_sellerWiseShippingOptionValidation.isNotEmpty &&  carrier_base_shipping.$){
      ToastComponent.showDialog(LangText(context).local.common_invalid_warning,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    shippingCostResponse =
    await AddressRepository().getShippingCostResponse(
        shipping_type: _sellerWiseShippingOption);

    if (shippingCostResponse.result == false) {
      ToastComponent.showDialog(LangText(context).local.common_network_error,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Checkout(
          title: AppLocalizations
              .of(context)
              .checkout_screen_checkout,
        paymentFor: PaymentFor.Order,
      );
    })).then((value) {
      onPopped(value);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery
        .of(context)
        .size
        .height;
    mWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          appBar: customAppBar(context),
          bottomNavigationBar: buildBottomAppBar(context),
          body: buildBody(context)),
    );
  }

  RefreshIndicator buildBody(BuildContext context) {
    return RefreshIndicator(
      color: MyTheme.accent_color,
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      displacement: 0,
      child: Container(
        child: buildBodyChildren(context),
      ),
    );
  }

  Widget buildBodyChildren(BuildContext context) {
    return buildCartSellerList();
  }

  Container buildShippingListContainer(BuildContext context, index) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      child: CustomScrollView(
        controller: _mainScrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
                buildShippingListBody(index),
                SizedBox(
                  height: 100,
                )
              ]))
        ],
      ),
    );
  }

  Widget buildShippingListBody(sellerIndex) {
    return _sellerWiseShippingOption[sellerIndex].shippingOption !=
        ShippingOption.PickUpPoint
        ? buildHomeDeliveryORCarrier(sellerIndex)
        : buildPickupPoint(sellerIndex);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) =>
            IconButton(
              icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
      ),
      title: Text(
        "${AppLocalizations
            .of(context)
            .shipping_info_screen_shipping_cost} ${_shipping_cost_string}",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildHomeDeliveryORCarrier(sellerArrayIndex) {
    if (carrier_base_shipping.$) {
      return buildCarrierSection(sellerArrayIndex);
    } else {
      return Container();
    }
  }
/*
  buildHomeDeliveryInfo() {
    if (is_logged_in.$ == false) {
      return buildLoginWarning();
    }
    else if (!_homeDeliveryAddressFetch && _shippingAddressList.length == 0) {
      return Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: MyTheme.accent_color,
          ),
        ),
      );
    } else if (_shippingAddressList.length > 0) {
      return ListView.builder(
        itemCount: _shippingAddressList.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: buildHomeDeliveryItemCard(index),
          );
        },
      );
    } else if (_isInitial && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                LangText(context).local.common_no_address_added,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    }
  }*/

  Container buildLoginWarning() {
    return Container(
        height: 100,
        child: Center(
            child: Text(
              LangText(context).local.common_login_warning,
              style: TextStyle(color: MyTheme.font_grey),
            )));
  }
/*
  Widget buildHomeDeliveryItemCard(index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: MyTheme.accent_color, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildHomeDeliveryChildren(index),
      ),
    );
  }


  Column buildHomeDeliveryChildren(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHomeDeliveryItemAddress(index),
        buildHomeDeliveryItemCity(index),
        buildHomeDeliveryItemState(index),
        buildHomeDeliveryItemCountry(index),
        buildHomeDeliveryItemPostalCode(index),
        buildHomeDeliveryItemPhone(index),
      ],
    );
  }

  Padding buildHomeDeliveryItemPhone(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local.shipping_info_screen_phone,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].phone,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildHomeDeliveryItemPostalCode(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local.order_details_screen_postal_code,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].postal_code,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildHomeDeliveryItemCountry(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local.shipping_info_screen_country,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].country_name,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildHomeDeliveryItemState(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local.shipping_info_screen_state,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].state_name,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildHomeDeliveryItemCity(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local.shipping_info_screen_city,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].city_name,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildHomeDeliveryItemAddress(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              LangText(context).local.shipping_info_screen_address,
              style: TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 175,
            child: Text(
              _shippingAddressList[index].address,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
*/
  Widget buildPickupPoint(sellerArrayIndex) {
    if (is_logged_in.$ == false) {
      return buildLoginWarning();
    } else if (_isFetchDeliveryInfo && _deliveryInfoList.length == 0) {
      return buildCarrierShimmer();
    } else if (_deliveryInfoList[sellerArrayIndex].pickupPoints.length > 0) {
      return ListView.separated(
        separatorBuilder: (context,index)=>SizedBox(height: 14,),
        itemCount: _deliveryInfoList[sellerArrayIndex].pickupPoints.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildPickupPointItemCard(index, sellerArrayIndex);
        },
      );
    } else if (_isFetchDeliveryInfo && _deliveryInfoList[sellerArrayIndex].pickupPoints.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations
                    .of(context)
                    .no_pickup_point,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    }
  }

  GestureDetector buildPickupPointItemCard(pickupPointIndex, sellerArrayIndex) {
    return GestureDetector(
      onTap: () {
        if (_sellerWiseShippingOption[sellerArrayIndex].shippingId !=
            _deliveryInfoList[sellerArrayIndex].pickupPoints[pickupPointIndex]
                .id) {
          _sellerWiseShippingOption[sellerArrayIndex].shippingId =
              _deliveryInfoList[sellerArrayIndex].pickupPoints[pickupPointIndex]
                  .id;
        }
        setState(() {});
        getSetShippingCost();
      },
      child: Container(
        decoration: BoxDecorations.buildBoxDecoration_1(radius: 8).copyWith(
          border:_sellerWiseShippingOption[sellerArrayIndex].shippingId ==
              _deliveryInfoList[sellerArrayIndex].pickupPoints[pickupPointIndex]
                  .id?
          Border.all(color: MyTheme.accent_color, width: 1.0)
          :Border.all(color: MyTheme.light_grey, width: 1.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildPickUpPointInfoItemChildren(
              pickupPointIndex, sellerArrayIndex),
        ),
      ),
    );
  }

  Column buildPickUpPointInfoItemChildren(pickupPointIndex, sellerArrayIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 75,
                child: Text(
                  AppLocalizations
                      .of(context)
                      .shipping_info_screen_address,
                  style: TextStyle(
                    fontSize: 13,
                    color: MyTheme.dark_font_grey,
                  ),
                ),
              ),
              Container(
                width: 175,
                child: Text(
                  _deliveryInfoList[sellerArrayIndex]
                      .pickupPoints[pickupPointIndex].name,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 13,
                      color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
                ),
              ),
              Spacer(),
              buildShippingSelectMarkContainer(
                  _sellerWiseShippingOption[sellerArrayIndex].shippingId ==
                      _deliveryInfoList[sellerArrayIndex]
                          .pickupPoints[pickupPointIndex].id)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 75,
                child: Text(
                  AppLocalizations
                      .of(context)
                      .address_screen_phone,
                  style: TextStyle(
                    fontSize: 13,
                    color: MyTheme.dark_font_grey,
                  ),
                ),
              ),
              Container(
                width: 200,
                child: Text(
                  _deliveryInfoList[sellerArrayIndex]
                      .pickupPoints[pickupPointIndex].phone,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 13,
                      color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCarrierSection(sellerArrayIndex) {
    if (is_logged_in.$ == false) {
      return buildLoginWarning();
    } else if (!_isFetchDeliveryInfo) {
      return buildCarrierShimmer();
    } else if (_deliveryInfoList[sellerArrayIndex].carriers.data.length > 0) {
      return Container(
          child: buildCarrierListView(sellerArrayIndex));
    } else {
      return buildCarrierNoData();
    }
  }

  Container buildCarrierNoData() {
    return Container(
        height: 100,
        child: Center(
            child: Text(
              AppLocalizations
                  .of(context)
                  .shipping_info_screen_no_carrier_point,
              style: TextStyle(color: MyTheme.font_grey),
            )));
  }

  Widget buildCarrierListView(sellerArrayIndex) {
    return ListView.separated(
      itemCount: _deliveryInfoList[sellerArrayIndex].carriers.data.length,
      scrollDirection: Axis.vertical,
      separatorBuilder: (context,index){
        return SizedBox(height:14,);
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // if (_sellerWiseShippingOption[sellerArrayIndex].shippingId == 0) {
        //   _sellerWiseShippingOption[sellerArrayIndex].shippingId = _deliveryInfoList[sellerArrayIndex].carriers.data[index].id;
        //   setState(() {});
        // }
        return buildCarrierItemCard(index, sellerArrayIndex);
      },
    );
  }

  Widget buildCarrierShimmer() {
    return ShimmerHelper().buildListShimmer(item_count: 2, item_height: 50.0);
  }

  GestureDetector buildCarrierItemCard(carrierIndex, sellerArrayIndex) {
    return GestureDetector(
      onTap: () {
        if (_sellerWiseShippingOption[sellerArrayIndex].shippingId !=
            _deliveryInfoList[sellerArrayIndex].carriers.data[carrierIndex]
                .id) {
          _sellerWiseShippingOption[sellerArrayIndex].shippingId =
              _deliveryInfoList[sellerArrayIndex].carriers.data[carrierIndex]
                  .id;
          setState(() {});
          getSetShippingCost();
        }
      },
      child: Container(
        decoration: BoxDecorations.buildBoxDecoration_1(radius: 8).copyWith(
            border:_sellerWiseShippingOption[sellerArrayIndex].shippingId ==
                _deliveryInfoList[sellerArrayIndex].carriers.data[carrierIndex]
                    .id?
            Border.all(color: MyTheme.accent_color, width: 1.0)
                :Border.all(color: MyTheme.light_grey, width: 1.0)
        ),
        child: buildCarrierInfoItemChildren(carrierIndex, sellerArrayIndex),
      ),
    );
  }

  Widget buildCarrierInfoItemChildren(carrierIndex, sellerArrayIndex) {
    return Stack(
      children: [
        Container(
          width: DeviceInfo(context).width/1.3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyImage.imageNetworkPlaceholder(
                  height: 75.0,
                  width: 75.0,
                  radius: BorderRadius.only(topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6)),
                  url: _deliveryInfoList[sellerArrayIndex].carriers
                      .data[carrierIndex].logo),

              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: DeviceInfo(context).width / 3,
                      child: Text(
                        _deliveryInfoList[sellerArrayIndex].carriers
                            .data[carrierIndex].name,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 13,
                            color: MyTheme.dark_font_grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        _deliveryInfoList[sellerArrayIndex].carriers
                            .data[carrierIndex].transitTime.toString() + " " +
                            LangText(context).local.common_day,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 13,
                            color: MyTheme.dark_font_grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                child: Text(
                  _deliveryInfoList[sellerArrayIndex].carriers.data[carrierIndex]
                      .transitPrice.toString(),
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 13,
                      color: MyTheme.dark_font_grey, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 16,)
            ],
          ),
        ),

        Positioned(
          right: 16,
          top: 10,
          child: buildShippingSelectMarkContainer(
              _sellerWiseShippingOption[sellerArrayIndex].shippingId ==
                  _deliveryInfoList[sellerArrayIndex].carriers
                      .data[carrierIndex].id),
        )

      ],
    );
  }


  Container buildShippingSelectMarkContainer(bool check) {
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
              minWidth: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 50,
              color: MyTheme.accent_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                AppLocalizations
                    .of(context)
                    .shipping_info_screen_btn_proceed_to_checkout,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressProceed(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget customAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: MyTheme.white,
      automaticallyImplyLeading: false,
      title: buildAppbarTitle(context),
      leading: UsefulElements.backButton(context),
    );
  }

  Container buildAppbarTitle(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 40,
      child: Text(
        "${AppLocalizations
            .of(context)
            .shipping_info_screen_shipping_cost} ${_shipping_cost_string}",
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Container buildAppbarBackArrow() {
    return Container(
      width: 40,
      child: UsefulElements.backButton(context),
    );
  }

  Widget buildChooseShippingOptions(BuildContext context, sellerIndex) {
    return Container(
      color: MyTheme.white,
      //MyTheme.light_grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(carrier_base_shipping.$)
            buildCarrierOption(context, sellerIndex)
          else
            buildAddressOption(context, sellerIndex),
          SizedBox(width: 14,),
          if(pick_up_status.$)
          buildPickUpPointOption(context, sellerIndex),
        ],
      ),
    );
  }

  FlatButton buildPickUpPointOption(BuildContext context, sellerIndex) {
    return FlatButton(
      color: _sellerWiseShippingOption[sellerIndex].shippingOption ==
          ShippingOption.PickUpPoint ? MyTheme.accent_color : MyTheme
          .accent_color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: MyTheme.accent_color)
      ),
      padding: EdgeInsets.only(right: 14),
      onPressed: () {
        setState(() {
          changeShippingOption(ShippingOption.PickUpPoint, sellerIndex);
        });
      },
      child: Container(
        alignment: Alignment.center,
        height:30,
        //width: (mWidth / 4) - 1,
        child: Row(
          children: [
            Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (!states.contains(MaterialState.selected)) {
                    return MyTheme.accent_color;
                  }
                  return MyTheme.white ;
                }),
                value: ShippingOption.PickUpPoint,
                groupValue: _sellerWiseShippingOption[sellerIndex]
                    .shippingOption,
                onChanged: (newOption) {
                  changeShippingOption(newOption, sellerIndex);
                }),
            //SizedBox(width: 10,),
            Text(
              AppLocalizations
                  .of(context)
                  .pickup_point,
              style: TextStyle(
                fontSize: 12,
                  color: _sellerWiseShippingOption[sellerIndex]
                      .shippingOption == ShippingOption.PickUpPoint
                      ? MyTheme.white
                      : MyTheme.accent_color,
                  fontWeight: _sellerWiseShippingOption[sellerIndex]
                      .shippingOption == ShippingOption.PickUpPoint
                      ? FontWeight.w700
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  FlatButton buildAddressOption(BuildContext context, sellerIndex) {
    return FlatButton(
      color: _sellerWiseShippingOption[sellerIndex].shippingOption ==
          ShippingOption.HomeDelivery ? MyTheme.accent_color : MyTheme
          .accent_color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: MyTheme.accent_color)
      ),
      padding: EdgeInsets.only(right: 14),
      onPressed: () {
        changeShippingOption(ShippingOption.HomeDelivery, sellerIndex);
      },
      child: Container(
        height: 30,
        // width: (mWidth / 4) - 1,
        alignment: Alignment.center,
        child: Row(
          children: [
            Radio(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (!states.contains(MaterialState.selected)) {
                    return MyTheme.accent_color;
                  }
                  return MyTheme.white ;
                }),
                value: ShippingOption.HomeDelivery,
                groupValue: _sellerWiseShippingOption[sellerIndex]
                    .shippingOption,
                onChanged: (newOption) {
                  changeShippingOption(newOption, sellerIndex);
                }),
            Text(
              AppLocalizations
                  .of(context)
                  .shipping_info_screen_home_delivery,
              style: TextStyle(
                  fontSize: 12,
                  color: _sellerWiseShippingOption[sellerIndex]
                      .shippingOption == ShippingOption.HomeDelivery
                      ? MyTheme.white
                      : MyTheme.accent_color,
                  fontWeight: _sellerWiseShippingOption[sellerIndex]
                      .shippingOption == ShippingOption.HomeDelivery
                      ? FontWeight.w700
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  FlatButton buildCarrierOption(BuildContext context, sellerIndex) {
    return FlatButton(
      color: _sellerWiseShippingOption[sellerIndex].shippingOption ==
          ShippingOption.Carrier ? MyTheme.accent_color : MyTheme
          .accent_color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: MyTheme.accent_color)
      ),
      padding: EdgeInsets.only(right: 14),
      onPressed: () {
        changeShippingOption(ShippingOption.Carrier, sellerIndex);
      },
      child: Container(
        height: 30,
        // width: (mWidth / 4) - 1,
        alignment: Alignment.center,
        child: Row(
          children: [
            Radio(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (!states.contains(MaterialState.selected)) {
                    return MyTheme.accent_color;
                  }
                  return MyTheme.white ;
                }),
                value: ShippingOption.Carrier,
                groupValue: _sellerWiseShippingOption[sellerIndex]
                    .shippingOption,
                onChanged: (newOption) {
                  changeShippingOption(newOption, sellerIndex);
                }),
            Text(
              AppLocalizations
                  .of(context)
                  .shipping_info_screen_no_carrier,
              style:  TextStyle(
                  fontSize: 12,
                  color: _sellerWiseShippingOption[sellerIndex]
                      .shippingOption == ShippingOption.Carrier
                      ? MyTheme.white
                      : MyTheme.accent_color,
                  fontWeight: _sellerWiseShippingOption[sellerIndex]
                      .shippingOption == ShippingOption.Carrier
                      ? FontWeight.w700
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }


  buildCartSellerList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations
                    .of(context)
                    .cart_screen_please_log_in,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    }
    else if (_isFetchDeliveryInfo && _deliveryInfoList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    }
    else if (_deliveryInfoList.length > 0) {
      return buildCartSellerListBody();
    } else if (_isFetchDeliveryInfo && _deliveryInfoList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations
                    .of(context)
                    .cart_screen_cart_empty,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    }
  }

  SingleChildScrollView buildCartSellerListBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 20),
          separatorBuilder: (context, index) =>
              SizedBox(
                height: 26,
              ),
          itemCount: _deliveryInfoList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildCartSellerListItem(index, context);
          },
        ),
      ),
    );
  }

  Column buildCartSellerListItem(int index, BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  _deliveryInfoList[index].name,
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
              buildCartSellerItemList(index),

              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(

                  LangText(context).local
                      .shipping_info_screen_address_choose_delivery,
                  style: TextStyle(
                      color: MyTheme.dark_font_grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
              ),
              SizedBox(height: 5,),
              buildChooseShippingOptions(context, index),
              SizedBox(height: 10,),
              buildShippingListBody(index),
            ],
          );
  }


  SingleChildScrollView buildCartSellerItemList(seller_index) {
    return SingleChildScrollView(
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            SizedBox(
              height: 14,
            ),
        itemCount: _deliveryInfoList[seller_index].cartItems.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildCartSellerItemCard(index, seller_index);
        },
      ),
    );
  }

  buildCartSellerItemCard(itemIndex, sellerIndex) {
    return Container(
      height: 80,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: DeviceInfo(context).width / 4,
                height: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(6), right: Radius.zero),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: _deliveryInfoList[sellerIndex]
                          .cartItems[itemIndex]
                          .productThumbnailImage,
                      fit: BoxFit.cover,
                    ))),
            SizedBox(width: 10,),
            Container(
              //color: Colors.red,
              width: DeviceInfo(context).width / 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _deliveryInfoList[sellerIndex]
                          .cartItems[itemIndex]
                          .productName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}

enum ShippingOption { HomeDelivery, PickUpPoint, Carrier }

class SellerWithShipping {
  int sellerId;
  ShippingOption shippingOption;
  int shippingId;

  SellerWithShipping(this.sellerId, this.shippingOption, this.shippingId);

  Map toJson() =>
      {
        'seller_id': sellerId,
        'shipping_type': shippingOption == ShippingOption.HomeDelivery
            ? "home_delivery"
            : shippingOption == ShippingOption.Carrier
            ? "carrier"
            : "pickup_point",
        'shipping_id': shippingId,
      };

}
//
// class SellerWithForReqBody{
//   int sellerId;
//   String shippingType;
//
//   SellerWithForReqBody(this.sellerId, this.shippingType);
// }
