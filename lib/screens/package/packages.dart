import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/enum_classes.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/style.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/customer_package_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/customer_package_repository.dart';
import 'package:active_ecommerce_flutter/screens/checkout.dart';
import 'package:flutter/material.dart';

class UpdatePackage extends StatefulWidget {
  const UpdatePackage({Key key}) : super(key: key);

  @override
  State<UpdatePackage> createState() => _UpdatePackageState();
}

class _UpdatePackageState extends State<UpdatePackage> {
  List<Package> _packages = [];
  bool _isFetchAllData = false;


  Future<bool> getPackageList() async {
    var response = await CustomerPackageRepository().getList();
    _packages.addAll(response.data);
    setState(() {});
    return true;
  }





  Future<bool> sendFreePackageReq(id) async {
    // var response = await ShopRepository().purchaseFreePackageRequest(id);
    // ToastComponent.showDialog(response.message,
    //     gravity: Toast.center, duration: Toast.lengthLong);
    // setState(() {});
    return true;
  }



  Future<bool> fetchData() async {

    await getPackageList();
    _isFetchAllData = true;
    setState(() {});
    return true;
  }

  clearData() {
    _isFetchAllData = false;
    _packages = [];
    setState(() {});
  }

  Future<bool> resetData() {
    clearData();
    return fetchData();
  }

  Future<void> refresh() async {
    await resetData();
    return Future.delayed(const Duration(seconds: 0));
  }

  // sendPaymentPage({int package_id,String payment_method_key, amount}) {
  //   switch (payment_method_key) {
  //     case "stripe":
  //       MyTransaction(context: context).push(StripeScreen(
  //         amount: double.parse(amount.toString()),
  //         payment_method_key: payment_method_key,
  //         payment_type: "seller_package_payment",
  //       ));
  //       break;
  //
  //     case "iyzico":
  //       MyTransaction(context: context).push(
  //           IyzicoScreen(
  //         amount: double.parse(amount.toString()),
  //         payment_method_key: payment_method_key,
  //         payment_type: "seller_package_payment",
  //       ));
  //       break;
  //
  //     case "bkash":
  //       MyTransaction(context: context).push(
  //           BkashScreen(
  //         amount: double.parse(amount.toString()),
  //         payment_method_key: payment_method_key,
  //         payment_type: "seller_package_payment",
  //       ));
  //       break;
  //
  //     case "paytm":
  //       MyTransaction(context: context).push(
  //           PaytmScreen(
  //         amount: double.parse(amount.toString()),
  //         payment_method_key: payment_method_key,
  //         payment_type: "seller_package_payment",
  //       ));
  //       break;
  //     case "paypal_payment":
  //       MyTransaction(context: context).push(PaypalScreen(
  //         amount: double.parse(amount.toString()),
  //         payment_method_key: payment_method_key,
  //         payment_type: "seller_package_payment",
  //       ));
  //       break;
  //
  //     default:
  //       print("Die ");
  //       print("$payment_method_key ");
  //       break;
  //   }
  // }

  @override
  void initState() {
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
              backgroundColor: MyTheme.white,
              title:Text( LangText( context)
                  .local
                  .package_screen_title,
                style: MyStyle.appBarStyle,
              ),
        //leadingWidth: 20,
        leading: UsefulElements.backButton(context),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: buildList(),
          ),
        ),
      ),
    );
  }

  ListView buildList() {
    return _isFetchAllData
        ? ListView.separated(
      padding: EdgeInsets.only(top: 10),
      separatorBuilder: (context,index){
        return SizedBox(height: 10,);
      },
            itemCount: _packages.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return packageItem(
                index,
                context,
                _packages[index].logo,
                _packages[index].name,
                _packages[index].amount,
                _packages[index].productUploadLimit.toString(),
                _packages[index].price,
                _packages[index].id,
              );
            })
        : loadingShimmer();
  }

  Widget loadingShimmer() {
    return ShimmerHelper().buildListShimmer(item_count: 10, item_height: 170.0);
  }

  Widget packageItem(int index,BuildContext context, String url, String packageName,
      String packagePrice, String packageProduct, price,package_id) {
    print(url);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
        decoration: BoxDecorations.buildBoxDecoration_1(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            UsefulElements.roundImageWithPlaceholder(width: 30.0, height: 30.0, url: url,backgroundColor: MyTheme.noColor),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                packageName,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: DeviceInfo(context).width / 2,

                decoration: BoxDecoration(
                    color: MyTheme.accent_color,
                  borderRadius: BorderRadius.circular(6)
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                    onTap: () {
                      if(double.parse(price.toString())<=0){
                        sendFreePackageReq(package_id);
                        return;
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Checkout(title: "Purchase Package",rechargeAmount: double.parse(price.toString()),paymentFor: PaymentFor.PackagePay,)));
                      }
                    },
                    radius: 3.0,
                    child: Text(
                      packagePrice,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MyTheme.white),
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: DeviceInfo(context).width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: MyTheme.accent_color,
                      size: 11,
                    ),
                    Text(
                      packageProduct +
                          " " +
                          LangText( context)
                              .local
                              .package_screen_product_upload_limit,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
/*
  selectOnlinePaymentType(amount,package_id) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: AlertDialog(
                title: Text(LangText( context)
                    .local
                    .package_upgrade_screen_payment_type),
                content: DropdownButton<PaymentTypeResponse>(
                  underline: Container(),
                  elevation: 2,
                  isExpanded: true,
                  items: _onlinePaymentList
                      .map<DropdownMenuItem<PaymentTypeResponse>>(
                          (paymentType) => DropdownMenuItem(
                                child: Text(paymentType.name),
                            value: paymentType,
                              ))
                      .toList(),
                  value: _selectedOnlinePaymentTypeValue,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedOnlinePaymentTypeValue = newValue;
                    });
                  },
                ),
                actions: [
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.red,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LangText(context: context).getLocal().common_cancel,
                        style: TextStyle(color: MyTheme.white, fontSize: 12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5)),
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.green,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                        sendPaymentPage(
                          payment_method_key: _selectedOnlinePaymentTypeValue.payment_type_key,
                          amount: amount,
                          package_id: package_id
                        );
                      },
                      child: Text(
                          LangText(context: context).getLocal().common_continue,
                          style: TextStyle(color: MyTheme.white, fontSize: 12)),
                      padding: EdgeInsets.symmetric(horizontal: 5))
                ],
              ),
            );
          });
        });
  }

  selectOfflinePaymentType(amount,package_id) {

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: AlertDialog(
                title: Text(LangText(context: context)
                    .getLocal()
                    .package_upgrade_screen_payment_type),
                content: DropdownButton<PaymentTypeResponse>(
                  underline: Container(),
                  elevation: 2,
                  isExpanded: true,
                  items: _offlinePaymentList
                      .map<DropdownMenuItem<PaymentTypeResponse>>(
                          (paymentType) => DropdownMenuItem(
                                child: Text(paymentType.name),
                                value: paymentType,
                              ))
                      .toList(),
                  value: _selectedOfflinePaymentTypeValue,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedOfflinePaymentTypeValue = newValue;
                    });
                  },
                ),
                actions: [
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.red,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LangText(context: context).getLocal().common_cancel,
                        style: TextStyle(color: MyTheme.white, fontSize: 12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5)),
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.green,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                        MyTransaction(context: context).push(
                            OfflineScreen(details:_selectedOfflinePaymentTypeValue.details, offline_payment_id:_selectedOfflinePaymentTypeValue.offline_payment_id,rechargeAmount:double.parse(amount.toString()),
                            package_id: package_id,
                            ));
                        // sendPaymentPage(
                        //   payment_method_key: _selectedOnlinePaymentTypeValue.key,
                        //   amount: amount,
                        // );
                      },
                      child: Text(
                          LangText(context: context).getLocal().common_continue,
                          style: TextStyle(color: MyTheme.white, fontSize: 12)),
                      padding: EdgeInsets.symmetric(horizontal: 5))
                ],
              ),
            );
          });
        });
  }

  selectPaymentOption(amount,package_id) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: AlertDialog(
                title: Text(LangText(context: context)
                    .getLocal()
                    .package_upgrade_screen_payment_option),
                content: DropdownButton<PaymentType>(
                  underline: Container(),
                  elevation: 2,
                  isExpanded: true,
                  items: _paymentOptions
                      .map<DropdownMenuItem<PaymentType>>(
                          (paymentType) => DropdownMenuItem(
                                child: Text(paymentType.value),
                                value: paymentType,
                              ))
                      .toList(),
                  value: _selectedPaymentOption,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPaymentOption = newValue;
                    });
                    Navigator.pop(context);
                    if (_selectedPaymentOption.key == "online") {
                      selectOnlinePaymentType(amount,package_id);
                    }
                    if (_selectedPaymentOption.key == "offline") {
                      selectOfflinePaymentType(amount,package_id);
                     // MyTransaction(context: context).push(OfflineScreen());
                    }

                  },
                ),
                actions: [
                  SubmitBtn.show(
                      radius: 5,
                      backgroundColor: MyTheme.red,
                      width: 40,
                      height: 30,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LangText(context: context).getLocal().common_cancel,
                        style: TextStyle(color: MyTheme.white, fontSize: 12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5)),
                ],
              ),
            );
          });
        });
  }*/
}
