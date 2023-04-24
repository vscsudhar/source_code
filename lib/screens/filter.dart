import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/shop_square_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/brand_square_card.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/brand_repository.dart';
import 'package:active_ecommerce_flutter/repositories/shop_repository.dart';
import 'package:active_ecommerce_flutter/helpers/reg_ex_inpur_formatter.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:active_ecommerce_flutter/repositories/search_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_context/one_context.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WhichFilter {
  String option_key;
  String name;

  WhichFilter(this.option_key, this.name);

  static List<WhichFilter> getWhichFilterList() {
    return <WhichFilter>[
      WhichFilter('product', AppLocalizations.of(OneContext().context).filter_screen_product),
      WhichFilter('sellers', AppLocalizations.of(OneContext().context).filter_screen_sellers),
      WhichFilter('brands', AppLocalizations.of(OneContext().context).filter_screen_brands),
    ];
  }
}

class Filter extends StatefulWidget {
  Filter({
    Key key,
    this.selected_filter = "product",
  }) : super(key: key);

  final String selected_filter;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  ScrollController _productScrollController = ScrollController();
  ScrollController _brandScrollController = ScrollController();
  ScrollController _shopScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController _scrollController;
  WhichFilter _selectedFilter;
  String _givenSelectedFilterOptionKey; // may be it can come from another page
  var _selectedSort = "";

  List<WhichFilter> _which_filter_list = WhichFilter.getWhichFilterList();
  List<DropdownMenuItem<WhichFilter>> _dropdownWhichFilterItems;
  List<dynamic> _selectedCategories = [];
  List<dynamic> _selectedBrands = [];

  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController _minPriceController = new TextEditingController();
  final TextEditingController _maxPriceController = new TextEditingController();

  //--------------------
  List<dynamic> _filterBrandList = List();
  bool _filteredBrandsCalled = false;
  List<dynamic> _filterCategoryList = List();
  bool _filteredCategoriesCalled = false;

  List<dynamic> _searchSuggestionList = List();

  //----------------------------------------
  String _searchKey = "";

  List<dynamic> _productList = [];
  bool _isProductInitial = true;
  int _productPage = 1;
  int _totalProductData = 0;
  bool _showProductLoadingContainer = false;

  List<dynamic> _brandList = [];
  bool _isBrandInitial = true;
  int _brandPage = 1;
  int _totalBrandData = 0;
  bool _showBrandLoadingContainer = false;

  List<dynamic> _shopList = [];
  bool _isShopInitial = true;
  int _shopPage = 1;
  int _totalShopData = 0;
  bool _showShopLoadingContainer = false;

  //----------------------------------------

  fetchFilteredBrands() async {
    var filteredBrandResponse = await BrandRepository().getFilterPageBrands();
    _filterBrandList.addAll(filteredBrandResponse.brands);
    _filteredBrandsCalled = true;
    setState(() {});
  }

  fetchFilteredCategories() async {
    var filteredCategoriesResponse =
        await CategoryRepository().getFilterPageCategories();
    _filterCategoryList.addAll(filteredCategoriesResponse.categories);
    _filteredCategoriesCalled = true;
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _productScrollController.dispose();
    _brandScrollController.dispose();
    _shopScrollController.dispose();
    super.dispose();
  }

  init() {
    _givenSelectedFilterOptionKey = widget.selected_filter;

    _dropdownWhichFilterItems =
        buildDropdownWhichFilterItems(_which_filter_list);
    _selectedFilter = _dropdownWhichFilterItems[0].value;

    for (int x = 0; x < _dropdownWhichFilterItems.length; x++) {
      if (_dropdownWhichFilterItems[x].value.option_key ==
          _givenSelectedFilterOptionKey) {
        _selectedFilter = _dropdownWhichFilterItems[x].value;
      }
    }

    fetchFilteredCategories();
    fetchFilteredBrands();

    if (_selectedFilter.option_key == "sellers") {
      fetchShopData();
    } else if (_selectedFilter.option_key == "brands") {
      fetchBrandData();
    } else {
      fetchProductData();
    }

    //set scroll listeners

    _productScrollController.addListener(() {
      if (_productScrollController.position.pixels ==
          _productScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchProductData();
      }
    });

    _brandScrollController.addListener(() {
      if (_brandScrollController.position.pixels ==
          _brandScrollController.position.maxScrollExtent) {
        setState(() {
          _brandPage++;
        });
        _showBrandLoadingContainer = true;
        fetchBrandData();
      }
    });

    _shopScrollController.addListener(() {
      if (_shopScrollController.position.pixels ==
          _shopScrollController.position.maxScrollExtent) {
        setState(() {
          _shopPage++;
        });
        _showShopLoadingContainer = true;
        fetchShopData();
      }
    });
  }

  fetchProductData() async {
    //print("sc:"+_selectedCategories.join(",").toString());
    //print("sb:"+_selectedBrands.join(",").toString());
    var productResponse = await ProductRepository().getFilteredProducts(
        page: _productPage,
        name: _searchKey,
        sort_key: _selectedSort,
        brands: _selectedBrands.join(",").toString(),
        categories: _selectedCategories.join(",").toString(),
        max: _maxPriceController.text.toString(),
        min: _minPriceController.text.toString());

    _productList.addAll(productResponse.products);
    _isProductInitial = false;
    _totalProductData = productResponse.meta.total;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  resetProductList() {
    _productList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchBrandData() async {
    var brandResponse =
        await BrandRepository().getBrands(page: _brandPage, name: _searchKey);
    _brandList.addAll(brandResponse.brands);
    _isBrandInitial = false;
    _totalBrandData = brandResponse.meta.total;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  resetBrandList() {
    _brandList.clear();
    _isBrandInitial = true;
    _totalBrandData = 0;
    _brandPage = 1;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  fetchShopData() async {
    var shopResponse =
        await ShopRepository().getShops(page: _shopPage, name: _searchKey);
    _shopList.addAll(shopResponse.shops);
    _isShopInitial = false;
    _totalShopData = shopResponse.meta.total;
    _showShopLoadingContainer = false;
    //print("_shopPage:" + _shopPage.toString());
    //print("_totalShopData:" + _totalShopData.toString());
    setState(() {});
  }

  reset() {
    _searchSuggestionList.clear();
    setState(() {});
  }

  resetShopList() {
    _shopList.clear();
    _isShopInitial = true;
    _totalShopData = 0;
    _shopPage = 1;
    _showShopLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onProductListRefresh() async {
    reset();
    resetProductList();
    fetchProductData();
  }

  Future<void> _onBrandListRefresh() async {
    reset();
    resetBrandList();
    fetchBrandData();
  }

  Future<void> _onShopListRefresh() async {
    reset();
    resetShopList();
    fetchShopData();
  }

  _applyProductFilter() {
    reset();
    resetProductList();
    fetchProductData();
  }

  _onSearchSubmit() {
    reset();
    if (_selectedFilter.option_key == "sellers") {
      resetShopList();
      fetchShopData();
    } else if (_selectedFilter.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  _onSortChange() {
    reset();
    resetProductList();
    fetchProductData();
  }

  _onWhichFilterChange() {
    if (_selectedFilter.option_key == "sellers") {
      resetShopList();
      fetchShopData();
    } else if (_selectedFilter.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  List<DropdownMenuItem<WhichFilter>> buildDropdownWhichFilterItems(
      List which_filter_list) {
    List<DropdownMenuItem<WhichFilter>> items = List();
    for (WhichFilter which_filter_item in which_filter_list) {
      items.add(
        DropdownMenuItem(
          value: which_filter_item,
          child: Text(which_filter_item.name),
        ),
      );
    }
    return items;
  }



  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalProductData == _productList.length
            ? AppLocalizations.of(context).common_no_more_products
            : AppLocalizations.of(context).common_loading_more_products),
      ),
    );
  }

  Container buildBrandLoadingContainer() {
    return Container(
      height: _showBrandLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalBrandData == _brandList.length
            ? AppLocalizations.of(context).common_no_more_brands
            : AppLocalizations.of(context).common_loading_more_brands),
      ),
    );
  }

  Container buildShopLoadingContainer() {
    return Container(
      height: _showShopLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalShopData == _shopList.length
            ? AppLocalizations.of(context).common_no_more_shops
            : AppLocalizations.of(context).common_loading_more_shops),
      ),
    );
  }

  //--------------------

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        endDrawer: buildFilterDrawer(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Stack(fit: StackFit.loose, children: [
          _selectedFilter.option_key == 'product'
              ? buildProductList()
              : (_selectedFilter.option_key == 'brands'
                  ? buildBrandList()
                  : buildShopList()),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: buildAppBar(context),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: _selectedFilter.option_key == 'product'
                  ? buildProductLoadingContainer()
                  : (_selectedFilter.option_key == 'brands'
                      ? buildBrandLoadingContainer()
                      : buildShopLoadingContainer()))
        ]),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white.withOpacity(0.95),
        automaticallyImplyLeading: false,
        actions: [
          new Container(),
        ],
        centerTitle: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
          child: Column(
            children: [buildTopAppbar(context), buildBottomAppBar(context)],
          ),
        ));
  }

  Row buildBottomAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                  vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                  horizontal: BorderSide(color: MyTheme.light_grey, width: 1))),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 36,
          width: MediaQuery.of(context).size.width * .33,
          child: new DropdownButton<WhichFilter>(
            icon: Padding(
              padding: app_language_rtl.$ ? const EdgeInsets.only(right: 18.0) :  const EdgeInsets.only(left: 18.0),
              child: Icon(Icons.expand_more, color: Colors.black54),
            ),
            hint: Text(
              AppLocalizations.of(context).filter_screen_products,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
            style: TextStyle(
                color: Colors.black,
                fontSize: 13),
            iconSize: 13,
            underline: SizedBox(),
            value: _selectedFilter,
            items: _dropdownWhichFilterItems,
            onChanged: (WhichFilter selectedFilter) {
              setState(() {
                _selectedFilter = selectedFilter;
              });

              _onWhichFilterChange();
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            _selectedFilter.option_key == "product"
                ? _scaffoldKey.currentState.openEndDrawer()
                : ToastComponent.showDialog(
                AppLocalizations.of(context).filter_screen_sort_warning,
                    gravity: Toast.center,
                    duration: Toast.lengthLong);
            ;
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: Center(
                child: Container(
              width: 50,
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 13,
                  ),
                  SizedBox(width: 2),
                  Text(
                    AppLocalizations.of(context).filter_screen_filter,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
        GestureDetector(
          onTap: () {
            _selectedFilter.option_key == "product"
                ? showDialog(
                    context: context,
                    builder: (_) => Directionality(
                      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
                      child: AlertDialog(
                            contentPadding: EdgeInsets.only(
                                top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
                            content: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                      child: Text(
                                        AppLocalizations.of(context).filter_screen_sort_products_by,
                                      )),
                                  RadioListTile(
                                    dense: true,
                                    value: "",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title:  Text(AppLocalizations.of(context).filter_screen_default),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "price_high_to_low",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title:  Text(AppLocalizations.of(context).filter_screen_price_high_to_low),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "price_low_to_high",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title:  Text(AppLocalizations.of(context).filter_screen_price_low_to_high),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "new_arrival",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title:  Text(AppLocalizations.of(context).filter_screen_price_new_arrival),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "popularity",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title:  Text(AppLocalizations.of(context).filter_screen_popularity),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "top_rated",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(AppLocalizations.of(context).filter_screen_top_rated),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            }),
                            actions: [
                              FlatButton(
                                child: Text(
                                  AppLocalizations.of(context).common_close_in_all_capital,
                                  style: TextStyle(color: MyTheme.medium_grey),
                                ),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ),
                            ],
                          ),
                    ))
                : ToastComponent.showDialog(
                AppLocalizations.of(context).filter_screen_filter_warning,
                    gravity: Toast.center,
                    duration: Toast.lengthLong);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: Center(
                child: Container(
              width: 50,
              child: Row(
                children: [
                  Icon(
                    Icons.swap_vert,
                    size: 13,
                  ),
                  SizedBox(width: 2),
                  Text(
                    "Sort",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )),
          ),
        )
      ],
    );
  }

  Row buildTopAppbar(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
        Widget>[
      IconButton(
        padding: EdgeInsets.zero,
        icon:UsefulElements.backButton(context),
        onPressed: () => Navigator.of(context).pop(),
      ),
      Container(
        width: MediaQuery.of(context).size.width * .6,
        child: Container(
          child: Padding(
              padding: MediaQuery.of(context).viewPadding.top >
                      30 //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ? const EdgeInsets.symmetric(vertical: 36.0, horizontal: 0.0)
                  : const EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
              child: TypeAheadField(
                suggestionsCallback: (pattern) async {
                  //return await BackendService.getSuggestions(pattern);
                  var suggestions =  await SearchRepository()
                      .getSearchSuggestionListResponse(query_key: pattern,type: _selectedFilter.option_key);
                  //print(suggestions.toString());
                  return suggestions;
                },
                loadingBuilder: (context){
                  return Container(
                    height: 50,
                    child: Center(child: Text(AppLocalizations.of(context).filter_screen_loading_suggestions,style:TextStyle(color: MyTheme.medium_grey))),
                  );
                },
                itemBuilder: (context, suggestion) {
                  //print(suggestion.toString());
                  var subtitle = "${AppLocalizations.of(context).filter_screen_searched_for} ${suggestion.count} ${AppLocalizations.of(context).filter_screen_times}";
                  if(suggestion.type != "search"){
                    subtitle = "${suggestion.type_string} ${AppLocalizations.of(context).filter_screen_found}";
                  }
                  return ListTile(
                    dense: true,
                    title: Text(suggestion.query,style: TextStyle(color:  suggestion.type != "search" ? MyTheme.accent_color : MyTheme.font_grey),),
                    subtitle: Text(subtitle,style:TextStyle(color: suggestion.type != "search" ? MyTheme.font_grey: MyTheme.medium_grey)),
                  );
                },
                noItemsFoundBuilder: (context){
                  return Container(
                    height: 50,
                    child: Center(child: Text(AppLocalizations.of(context).filter_screen_no_suggestion_available,style:TextStyle(color: MyTheme.medium_grey))),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _searchController.text = suggestion.query;
                  _searchKey = suggestion.query;
                  setState(() {});
                  _onSearchSubmit();
                },
                textFieldConfiguration: TextFieldConfiguration(
                  onTap: () {},
                  //autofocus: true,
                  controller: _searchController,
                  onSubmitted: (txt) {
                    _searchKey = txt;
                    setState(() {});
                    _onSearchSubmit();
                  },
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).filter_screen_search_here,
                      hintStyle: TextStyle(
                          fontSize: 12.0, color: MyTheme.textfield_grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyTheme.white, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyTheme.white, width: 0.0),
                      ),
                      contentPadding: EdgeInsets.all(0.0)),
                ),
              )),
        ),
      ),
      IconButton(
          icon: Icon(Icons.search, color: MyTheme.dark_grey),
          onPressed: () {
            _searchKey = _searchController.text.toString();
            setState(() {});
            _onSearchSubmit();
          }),
    ]);
  }

   buildFilterDrawer() {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          AppLocalizations.of(context).filter_screen_price_range,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 30,
                              width: 100,
                              child: TextField(
                                controller: _minPriceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_amountValidator],
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context).filter_screen_minimum,
                                    hintStyle: TextStyle(
                                        fontSize: 12.0,
                                        color: MyTheme.textfield_grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(4.0)),
                              ),
                            ),
                          ),
                          Text(" - "),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: 30,
                              width: 100,
                              child: TextField(
                                controller: _maxPriceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_amountValidator],
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context).filter_screen_maximum,
                                    hintStyle: TextStyle(
                                        fontSize: 12.0,
                                        color: MyTheme.textfield_grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(4.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          AppLocalizations.of(context).filter_screen_categories,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterCategoryList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).common_no_category_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterCategoryList(),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          AppLocalizations.of(context).filter_screen_brands,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).common_no_brand_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterBrandsList(),
                            ),
                    ]),
                  )
                ]),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      color: Color.fromRGBO(234, 67, 53, 1),
                      shape: RoundedRectangleBorder(
                        side:
                            new BorderSide(color: MyTheme.light_grey, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context).common_clear_in_all_capital,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _minPriceController.clear();
                        _maxPriceController.clear();
                        setState(() {
                          _selectedCategories.clear();
                          _selectedBrands.clear();
                        });
                      },
                    ),
                    FlatButton(
                      color: Color.fromRGBO(52, 168, 83, 1),
                      child: Text(
                        "APPLY",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        var min = _minPriceController.text.toString();
                        var max = _maxPriceController.text.toString();
                        bool apply = true;
                        if (min != "" && max != "") {
                          if (max.compareTo(min) < 0) {
                            ToastComponent.showDialog(
                                AppLocalizations.of(context).filter_screen_min_max_warning,
                                gravity: Toast.center,
                                duration: Toast.lengthLong);
                            apply = false;
                          }
                        }

                        if (apply) {
                          _applyProductFilter();
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView buildFilterBrandsList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterBrandList
            .map(
              (brand) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(brand.name),
                value: _selectedBrands.contains(brand.id),
                onChanged: (bool value) {
                  if (value) {
                    setState(() {
                      _selectedBrands.add(brand.id);
                    });
                  } else {
                    setState(() {
                      _selectedBrands.remove(brand.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterCategoryList
            .map(
              (category) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(category.name),
                value: _selectedCategories.contains(category.id),
                onChanged: (bool value) {
                  if (value) {
                    setState(() {
                      _selectedCategories.clear();
                      _selectedCategories.add(category.id);
                    });
                  } else {
                    setState(() {
                      _selectedCategories.remove(category.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  Container buildProductList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildProductScrollableList(),
          )
        ],
      ),
    );
  }

  buildProductScrollableList() {
    if (_isProductInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: _onProductListRefresh,
        child: SingleChildScrollView(
          controller: _productScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height:
                      MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                  //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              MasonryGridView.count(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _productList.length,
                controller: _scrollController,
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                padding: EdgeInsets.only(top:10,bottom: 10,left: 18,right: 18),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return ProductCard(
                      id: _productList[index].id,
                      image: _productList[index].thumbnail_image,
                      name: _productList[index].name,
                      main_price: _productList[index].main_price,
                      stroked_price: _productList[index].stroked_price,
                      has_discount: _productList[index].has_discount,
                      discount: _productList[index].discount,
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalProductData == 0) {
      return Center(child: Text( AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Container buildBrandList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildBrandScrollableList(),
          )
        ],
      ),
    );
  }

  buildBrandScrollableList() {
    if (_isBrandInitial && _brandList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildSquareGridShimmer(scontroller: _scrollController));
    } else if (_brandList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: _onBrandListRefresh,
        child: SingleChildScrollView(
          controller: _brandScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height:
                      MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                  //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _brandList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1),
                padding: EdgeInsets.only(top:20,bottom:10,left:18,right:18),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return BrandSquareCard(
                    id: _brandList[index].id,
                    image: _brandList[index].logo,
                    name: _brandList[index].name,
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalBrandData == 0) {
      return Center(child: Text(AppLocalizations.of(context).common_no_brand_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Container buildShopList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildShopScrollableList(),
          )
        ],
      ),
    );
  }

  buildShopScrollableList() {
    if (_isShopInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          controller: _scrollController,
          child: ShimmerHelper()
              .buildSquareGridShimmer(scontroller: _scrollController));
    } else if (_shopList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: _onShopListRefresh,
        child: SingleChildScrollView(
          controller: _shopScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height:
                      MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                  //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _shopList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.7),
                padding: EdgeInsets.only(top:20,bottom:10,left:18,right:18),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SellerDetails();
                      }));
                    },
                    child: ShopSquareCard(
                      id: _shopList[index].id,
                      image: _shopList[index].logo,
                      name: _shopList[index].name,
                      stars: double.parse(_shopList[index].rating.toString()) ,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalShopData == 0) {
      return Center(child: Text(AppLocalizations.of(context).common_no_shop_is_available));
    } else {
      return Container(); // should never be happening
    }
  }
}
