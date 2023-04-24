import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/common_functions.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/classified_ads_response.dart';
import 'package:active_ecommerce_flutter/data_model/customer_package_response.dart';
import 'package:active_ecommerce_flutter/data_model/user_info_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:active_ecommerce_flutter/screens/package/packages.dart';
import 'package:active_ecommerce_flutter/ui_elements/classified_product_card.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class MyClassifiedAds extends StatefulWidget {
  final bool fromBottomBar;

  const MyClassifiedAds({Key key, this.fromBottomBar = false}) : super(key: key);

  @override
  _MyClassifiedAdsState createState() => _MyClassifiedAdsState();
}

class _MyClassifiedAdsState extends State<MyClassifiedAds> {
  bool _isProductInit = false;
  bool _showMoreProductLoadingContainer = false;

  List<ClassifiedAdsMiniData> _productList = [];
  UserInformation _userInfo = null;

  // List<bool> _productStatus=[];
  // List<bool> _productFeatured=[];

  String _remainingProduct = "40";
  String _currentPackageName = "...";
  BuildContext loadingContext;
  BuildContext switchContext;
  BuildContext featuredSwitchContext;



  //MenuOptions _menuOptionSelected = MenuOptions.Published;

  ScrollController _scrollController =
  new ScrollController(initialScrollOffset: 0);

  // double variables
  double mHeight = 0.0, mWidht = 0.0;
  int _page = 1;

  getProductList() async {
    var productResponse = await ProductRepository().getOwnClassifiedProducts(page: _page);
    if (productResponse.data.isEmpty) {

      ToastComponent.showDialog(
          LangText( context).local.common_no_more_products,
          gravity: Toast.center,);
    }
    _productList.addAll(productResponse.data);
    _showMoreProductLoadingContainer = false;
    _isProductInit = true;
    setState(() {});
  }

  getUserInfo() async {

    var userInfoRes = await ProfileRepository().getUserInfoResponse();
    if(userInfoRes.data.isNotEmpty) {
      _userInfo = userInfoRes.data.first;
      _remainingProduct = _userInfo.remainingUploads.toString();
      _currentPackageName = _userInfo.packageName;
    }


    setState(() {});
  }

  // Future<bool> _getAccountInfo() async {
  //   var response = await ShopRepository().getShopInfo();
  //   _currentPackageName=response.shopInfo.sellerPackage;
  //   setState(() {});
  //   return true;
  // }




  deleteProduct(int id) async {
    loading();
    var response = await ProductRepository().getDeleteClassifiedProductResponse(id);
    Navigator.pop(loadingContext);
    if (response.result) {
      resetAll();
    }
    ToastComponent.showDialog(response.message,
      gravity: Toast.center,
      duration: 3,
    );
  }

  productStatusChange(int index, bool value, setState, id) async {
    loading();
    var response = await ProductRepository()
        .getStatusChangeClassifiedProductResponse(id,  value ? 1 : 0);
    Navigator.pop(loadingContext);
    if (response.result) {
      // _productStatus[index] = value;
      _productList[index].status = value;
      resetAll();
    }
    Navigator.pop(switchContext);
    ToastComponent.showDialog(response.message,
      gravity: Toast.center,
      duration: 3,
    );
  }


  scrollControllerPosition() {
    _scrollController.addListener(() {
      print("po");
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _showMoreProductLoadingContainer = true;
        setState(() {
          _page++;
        });
        getProductList();
      }
    });
  }

  cleanAll() {
    print("clean all");
    _isProductInit = false;
    _showMoreProductLoadingContainer = false;
    _productList = [];
    _page = 1;
    // _productStatus=[];
    // _productFeatured=[];
    _remainingProduct = "....";
    _currentPackageName="...";
    setState(() {});
  }

  fetchAll() {
    getProductList();
    getUserInfo();
    // _getAccountInfo();
    // getProductRemainingUpload();


  }

  resetAll() {
    cleanAll();
    fetchAll();
  }

  _tabOption(int index, productId, listIndex) {
    switch (index) {
      case 0:
        showChangeStatusDialog(listIndex, productId);
        break;
      case 1:
        showDeleteWarningDialog(productId);
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    scrollControllerPosition();
    fetchAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidht = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(LangText(context).local.my_classified_ads_screen_title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyTheme.dark_font_grey),),
          backgroundColor: MyTheme.white,
          leading: UsefulElements.backButton(context),
        ),
        body: buildBody(context),
      ),
      
    );
  }

  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        resetAll();
        // Future.delayed(Duration(seconds: 1));
      },
      child: Container(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          child: Column(
            children: [
              buildTop2BoxContainer(context),
              SizedBox(
                height: 16,
              ),
              Visibility(
                  visible: classified_product_status.$,
                  child: buildPackageUpgradeContainer(context)),
              SizedBox(
                height: 20,
              ),
              Container(
                child: _isProductInit
                    ? productsContainer()
                    : ShimmerHelper().buildListShimmer(
                    item_count: 20, item_height: 80.0),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget buildPackageUpgradeContainer(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18),
            padding: EdgeInsets.symmetric(horizontal: 14,vertical: 10),
            width: DeviceInfo(context).width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: MyTheme.accent_color,width: 1),
              color: MyTheme.accent_color.withOpacity(0.2),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdatePackage()));
              //  MyTransaction(context: context).push(Packages());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/package.png", height: 20, width: 20,),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        LangText( context)
                            .local
                            .my_classified_ads_screen_current_package,
                        style: TextStyle(fontSize: 10, color: MyTheme.grey_153),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _currentPackageName,
                        style: TextStyle(
                            fontSize: 10,
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        LangText( context)
                            .local
                            .my_classified_ads_screen_upgrade_package,
                        style: TextStyle(
                            fontSize: 12,
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Image.asset("assets/next_arrow.png",
                          color: MyTheme.accent_color,
                          height: 8.7, width: 7),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }


  Container buildTop2BoxContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //border: Border.all(color: MyTheme.app_accent_border),
                color: MyTheme.accent_color,
              ),
              height: 75,
              width: mWidht / 2 - 23,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      LangText(context)
                          .local
                          .my_classified_screen_product_screen_remaining_uploads,
                      style: CommonFunctions.dashboardBoxText(context),
                    ),
                    Text(
                      _remainingProduct,
                      style: CommonFunctions.dashboardBoxNumber(context),
                    ),
                  ],
                ),
              )),
          if(false)
          InkWell(
            onTap: (){
              ToastComponent.showDialog("Product add option is disable only for mobile app.",gravity: Toast.center,duration: Toast.lengthLong);
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //border: Border.all(color: MyTheme.app_accent_border),
                    color: MyTheme.amber_medium,
                    border: Border.all(color: MyTheme.dark_grey)
                ),
                height: 75,
                width: mWidht / 2 - 23,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        LangText(context).local.my_classified_ads_screen_add_new_products,
                        style: CommonFunctions.dashboardBoxText(context).copyWith(color: MyTheme.dark_grey,fontSize: 12),
                      ),
                      Image.asset("assets/add.png",
                          color: MyTheme.dark_grey,
                          height: 18, width:18),
                    ],
                  ),
                )),
          ),

        ],
      ),
    );
  }

  Widget productsContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LangText(context).local.home_screen_all_products,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MyTheme.accent_color),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.separated(
            separatorBuilder: (context,index)=>SizedBox(height: 10,),
              physics: NeverScrollableScrollPhysics(),
              itemCount: _productList.length + 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // print(index);
                if (index == _productList.length) {
                  return moreProductLoading();
                }
                return productItem(
                  index: index,
                    productId: _productList[index].id,
                    imageUrl: _productList[index].thumbnailImage,
                    productTitle: _productList[index].name,
                    category: _productList[index].category,
                    productPrice: _productList[index].unitPrice,
                    condition: _productList[index].condition.toString()
                );
              }),
        ],
      ),
    );
  }

  Widget productItem(
      {int index,
        productId,
        String imageUrl,
        String productTitle,
        category,
        String productPrice,
        String condition}) {
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
        
        child: Stack(
          children: [

            Row(
              children: [
                UsefulElements.roundImageWithPlaceholder(
                  width: 88.0,
                  height: 90.0,
                  fit: BoxFit.cover,
                  url: imageUrl,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),),),
                // Image.asset(ImageUrl,width: 80,height: 80,fit: BoxFit.contain,),
                SizedBox(
                  width: 11,
                ),
                Container(
                  width: mWidht - 129,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: mWidht - 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productTitle,
                                    style:
                                    TextStyle(fontSize: 13, color: MyTheme.font_grey,fontWeight: FontWeight.normal),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    category,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: MyTheme.grey_153,
                                        fontWeight: FontWeight.w400
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child:
                              showOptions(listIndex: index, productId: productId),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: true,
              child: Positioned.fill(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                    decoration: BoxDecoration(
                      color:condition=="new"?MyTheme.golden: MyTheme.accent_color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0),
                        bottomRight: Radius.circular(6.0),
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
                      condition??"",
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
        ));
  }


  showDeleteWarningDialog(id){
    showDialog(context: context, builder: (context)=>Container(
      width: DeviceInfo(context).width*1.5,
      child: AlertDialog(
        title: Text(LangText(context).local.common_delete_warning_text,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.red),),
        content: Text(LangText( context).local.common_delete_warning_text,style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        actions: [
          FlatButton(
              color: MyTheme.accent_color,
              onPressed: (){
                Navigator.pop(context);
              }, child: Text(LangText( context).local.common_no,style: TextStyle(color: MyTheme.white,fontSize: 12),)),
          FlatButton(
              color: MyTheme.accent_color,
              onPressed: (){
                Navigator.pop(context);
                 deleteProduct(id);
              }, child: Text(LangText(context).local.common_yes,style: TextStyle(color: MyTheme.white,fontSize: 12))),
        ],
      ),
    ));
  }

  Widget showOptions({listIndex, productId}) {
    return Container(
      width: 35,
      child: PopupMenuButton<MenuOptions>(

        offset: Offset(-12, 0),
        child: Padding(
          padding:  EdgeInsets.zero,
          child: Container(
            width: 35,
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.topRight,
            child: Image.asset("assets/more.png",
                width: 3, height: 15, fit: BoxFit.contain, color: MyTheme.grey_153),
          ),
        ),
        onSelected: (MenuOptions result) {
          _tabOption(result.index, productId, listIndex);
          // setState(() {
          //   _menuOptionSelected = result;
          // });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
          // const PopupMenuItem<MenuOptions>(
          //   value: MenuOptions.Edit,
          //   child: Text('Edit'),
          // ),

          const PopupMenuItem<MenuOptions>(
            value: MenuOptions.Status,
            child: Text('Status'),
          ),
          const PopupMenuItem<MenuOptions>(
            value: MenuOptions.Delete,
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void showChangeStatusDialog(int index, id) {
    //print(index.toString()+" "+_productStatus[index].toString());
    showDialog(
        context: context,
        builder: (context) {
          switchContext = context;
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 75,
              width: DeviceInfo(context).width,
              child: AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _productList[index].status ? "Published" : "Unpublished",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Switch(
                      value: _productList[index].status,
                      activeColor:Colors.green,
                      inactiveThumbColor: MyTheme.grey_153,
                      onChanged: (value) {
                        productStatusChange(index, value, setState, id);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }





  void showFeaturedUnFeaturedDialog(int index, id) {
    //print(_productFeatured[index]);
    print(index);
    showDialog(
        context: context,
        builder: (context) {
          featuredSwitchContext = context;
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 75,
              width: DeviceInfo(context).width,
              child: AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _productList[index].published ? "Published" : "UnPublished",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Switch(
                      value: _productList[index].published,
                      activeColor:Colors.green,
                      inactiveThumbColor: MyTheme.grey_153,
                      onChanged: (value) {
                        // productFeaturedChange(
                        //     index: index,
                        //     value: value,
                        //     setState: setState,
                        //     id: id);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Loading"),
                ],
              ));
        });
  }

  Widget moreProductLoading() {
    return _showMoreProductLoadingContainer
        ? Container(
      alignment: Alignment.center,
      child: SizedBox(
        height: 40,
        width: 40,
        child: Row(
          children: [
            SizedBox(
              width: 2,
              height: 2,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    )
        : SizedBox(
      height: 5,
      width: 5,
    );
  }

}

enum MenuOptions {Status,Delete}
