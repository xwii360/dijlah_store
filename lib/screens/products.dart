import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/all_atributes.dart';
import 'package:dijlah_store_ibtechiq/model/category.dart';
import 'package:dijlah_store_ibtechiq/model/banners.dart';
import 'package:dijlah_store_ibtechiq/model/category_brand.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/model/shop.dart';
import 'package:dijlah_store_ibtechiq/widget/banner_home.dart';
import 'package:dijlah_store_ibtechiq/widget/grid_banner_home.dart';
import 'package:dijlah_store_ibtechiq/screens/search.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:dijlah_store_ibtechiq/widget/product_grid.dart';
import 'package:dijlah_store_ibtechiq/widget/products_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class Products extends StatefulWidget {
  final BLoC bLoC;
  final id;
  final title;
  final getFrom;
  final pageId;
  const Products(
      {Key key, this.bLoC, this.id, this.title, this.getFrom, this.pageId})
      : super(key: key);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var chooseCategory = '';
  var chooseSubCategory = '';
  var chooseBrand = '';
  var chooseColor = '';
  var chooseAttribute = '';
  var chooseShop = '';
  var chooseTag = '';
  double chooseMinPrice = 0.0;
  double chooseMaxPrice = 10000000.0;
  bool chooseCard = true;
  ScrollController _controller;
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int page = 1;
  Timer timer;
  var selectedSortType = 'new_arrival';
  var chooseState = '';
  double _lowerValue = 0.0;
  double _upperValue = 10000000;
  @override
  void initState() {
    checkInternet(context).then((value) async {

      if (value == 'ok') {
        widget.bLoC.getAllAttributesFuture(widget.id);
        widget.bLoC.getAllColorsFilterFuture(widget.id);
        widget.bLoC.getAllBrandFilterFuture(widget.id);
        getMaxAndMinPrice(widget.id);
        getFrom();
        widget.bLoC
            .getProductsByFilter(
                selectedSortType,
                chooseShop,
                chooseBrand,
                chooseCategory,
                chooseSubCategory,
                chooseColor,
                chooseTag,
                chooseState,
                chooseAttribute,
                _lowerValue.toString(),
                _upperValue.toString())
            .then((value) => setState(() {
                  isLoading = false;
                }));
      }
    });
    super.initState();
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
  }

  getFrom() async {
    if (widget.getFrom == 'category') {
      setState(() {
        chooseCategory = widget.id.toString();
        chooseBrand = '';
        chooseShop = '';
      });
      widget.bLoC.getSubCategoryFuture(widget.id,'category');
      widget.bLoC.getCategoryBrandFuture(widget.id,'category');
      widget.bLoC.getCategoryBannersFuture(widget.id,'category');
    } else if (widget.getFrom == 'shop') {
      setState(() {
        chooseShop = widget.id.toString();
        chooseBrand = '';
        chooseCategory = '';
      });
    } else if (widget.getFrom == 'brand') {
      setState(() {
        chooseBrand = widget.id.toString();
        chooseCategory = '';
        chooseShop = '';
      });
    }
    else if (widget.getFrom == 'custom') {
      setState(() {
        chooseCategory = widget.id.toString();
        chooseBrand = '';
        chooseShop = '';
      });
      widget.bLoC.getSubCategoryFuture(widget.id,'custom');
      widget.bLoC.getCustomPageBrandFuture(widget.pageId);
      widget.bLoC.getCustomPageBannersFuture(widget.pageId);
    }
  else if (widget.getFrom == 'subCategory') {
  setState(() {
  chooseSubCategory = widget.id.toString();
  chooseBrand = '';
  chooseShop = '';
  chooseCategory = '';
  });
  widget.bLoC.getCategoryBrandFuture(widget.id,'subCategory');
  widget.bLoC.getCategoryBannersFuture(widget.id,'subCategory');
  }
    else {
      chooseCategory = widget.id.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool loading = false;
  _scrollListener() {
    var isEnd =  _controller.offset == _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        loading = true;
        page += 1;
        if (widget.getFrom == 'category' || widget.getFrom == 'custom' || widget.getFrom == 'subCategory') {
          widget.bLoC
              .getMoreProductsFilter(
                  selectedSortType,
                  chooseShop,
                  chooseBrand,
                  chooseCategory,
                  chooseSubCategory,
                  chooseColor,
                  chooseTag,
                  chooseState,
                  chooseAttribute,
                  _lowerValue.toString(),
                  _upperValue.toString(),
                  page)
              .then((value) => value == 'success' ? loading = false : null);
        } else if (widget.getFrom == 'shop') {
          widget.bLoC
              .getMoreProductsFilter(
                  selectedSortType,
                  chooseShop,
                  chooseBrand,
                  chooseCategory,
                  chooseSubCategory,
                  chooseColor,
                  chooseTag,
                  chooseState,
                  chooseAttribute,
                  _lowerValue.toString(),
                  _upperValue.toString(),
                  page)
              .then((value) => value == 'success' ? loading = false : null);
        } else if (widget.getFrom == 'brand') {
          widget.bLoC
              .getMoreProductsFilter(
                  selectedSortType,
                  chooseShop,
                  chooseBrand,
                  chooseCategory,
                  chooseSubCategory,
                  chooseColor,
                  chooseTag,
                  chooseState,
                  chooseAttribute,
                  _lowerValue.toString(),
                  _upperValue.toString(),
                  page)
              .then((value) => value == 'success' ? loading = false : null);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[300],
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
        child: Icon(Icons.filter_list),
      ),
      drawer: filter(),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: appBarTitle(widget.title??''),
        leading: backArrow(context),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: SizerUtil.deviceType == DeviceType.tablet?33:25,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: Search(
                        bLoC: widget.bLoC,
                      )));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50),
          child: Container(
            //  color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                chooseCard
                    ? SizedBox(
                        width: SizerUtil.deviceType == DeviceType.tablet?70:40,
                        child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                chooseCard = false;
                              });
                            },
                            child: Icon(
                              Icons.grid_view,
                              color: Colors.grey[600],
                              size: SizerUtil.deviceType == DeviceType.tablet?40:23,
                            )),
                      )
                    : SizedBox(
                        width: SizerUtil.deviceType == DeviceType.tablet?70:40,
                        child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                chooseCard = true;
                              });
                            },
                            child: Icon(
                              Icons.list,
                              color: Colors.grey[600],
                              size: SizerUtil.deviceType == DeviceType.tablet?40:23,
                            )),
                      ),
                Container(
                  height: 23,
                  width: 1.5,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 2,
                ),
                SizedBox(
                  width: SizerUtil.deviceType == DeviceType.tablet?75:45,
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        size: SizerUtil.deviceType == DeviceType.tablet?40:18,
                        color: Colors.grey[800],
                      ),
                      Text(
                        '${getTranslated(context, "filter")}',
                        style: TextStyle(fontFamily: "sans", fontSize: SizerUtil.deviceType == DeviceType.tablet?18:13),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: SizerUtil.deviceType == DeviceType.tablet ? 10 : 2,
                      bottom:
                          SizerUtil.deviceType == DeviceType.tablet ? 10 : 2),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      iconEnabledColor: Colors.white,
                      iconDisabledColor: Colors.white,
                      isExpanded: false,
                      hint: Text(
                        getTranslated(context, "sort_hint"),
                        style: TextStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.sp
                                : 12.sp),
                      ), // Not necessary for Option 1
                      value: selectedSortType,
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.sp
                              : 12.sp,
                          fontFamily: "sans",
                          color: Colors.black),
                      items: <String>[
                        "price_low_to_high",
                        "price_high_to_low",
                        "new_arrival",
                        "old_arrival",
                        "popularity",
                        "top_rated",
                        "today_deal",
                        "featured"
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            getTranslated(context, value),
                            style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 7.sp
                                        : 12.sp,
                                fontFamily: "sans",
                                color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedSortType = newValue;
                          isLoading = true;
                        });
                        checkInternet(context).then((value) async {
                          if (value == 'ok') {
                            widget.bLoC
                                .getProductsByFilter(
                                    newValue,
                                    chooseShop,
                                    chooseBrand,
                                      chooseCategory,
                                      chooseSubCategory,
                                    chooseColor,
                                    chooseTag,
                                    chooseState,
                                    chooseAttribute,
                                    _lowerValue.toString(),
                                    _upperValue.toString())
                                .then((value) => setState(() {
                                      isLoading = false;
                                    }));
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.getFrom == 'category' || widget.getFrom == 'custom')
              StreamBuilder<UnmodifiableListView<AllCategory>>(
                  stream: widget.getFrom == 'custom'?widget.bLoC.allSubCategoriesCustom:widget.bLoC.allSubCategories,
                  initialData: UnmodifiableListView<AllCategory>([]),
                  builder: (context, subCategorySnap) {
                    return subCategorySnap.hasData &&
                            subCategorySnap.data.isNotEmpty
                        ? SizedBox(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: subCategorySnap.data
                                  .map(
                                    (i) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Products(
                                                      bLoC: widget.bLoC,
                                                      id: i.id,
                                                      title: checkLanguage(
                                                          context,
                                                          i.arName,
                                                          i.enName,
                                                          i.kuName,
                                                          i.name),
                                                      getFrom: "subCategory",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: ClipRRect(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          child: Container(
                                            color: Color(0xffeff0f4),
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5),
                                            child: Center(
                                              child: Text(
                                                checkLanguage(context, i.arName,
                                                    i.enName, i.kuName, i.name),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: SizerUtil.deviceType == DeviceType.tablet?16:11,
                                                    color: Colors.black,
                                                    fontFamily: "sans"),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            height: 40,
                          )
                        : Container();
                  }),
            if (widget.getFrom == 'category' ||  widget.getFrom == 'subCategory' )
              StreamBuilder<UnmodifiableListView<CategoryBrands>>(
                  stream: widget.getFrom == 'subCategory'?widget.bLoC.allCategorySubCategoryBrands:widget.bLoC.allCategoryBrands,
                  initialData: UnmodifiableListView<CategoryBrands>([]),
                  builder: (context, subCategorySnap) {
                    return subCategorySnap.hasData &&
                            subCategorySnap.data.isNotEmpty
                        ? SizedBox(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: subCategorySnap.data
                                  .map<Widget>(
                                    (i) => SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: i.data
                                              .map<Widget>(
                                                (e) => GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Products(
                                                                      bLoC: widget
                                                                          .bLoC,
                                                                      id: e.id,
                                                                      title: checkLanguage(
                                                                          context,
                                                                          e.arName,
                                                                          e.enName,
                                                                          e.kuName,
                                                                          e.name),
                                                                      getFrom:
                                                                          "brand",
                                                                    )));
                                                  },
                                                  child: Card(
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(5.0),
                                                      child: Container(
                                                        color:
                                                            Color(0xffeff0f4),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5,
                                                                bottom: 5),
                                                        child: Center(
                                                          child: Text(
                                                            checkLanguage(
                                                                context,
                                                                e.arName,
                                                                e.enName,
                                                                e.kuName,
                                                                e.name),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: SizerUtil.deviceType == DeviceType.tablet?16:11,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "sans"),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList()),
                                    ),
                                  )
                                  .toList(),
                            ),
                            height: 40,
                          )
                        : Container();
                  }),
            if (widget.getFrom == 'category' ||  widget.getFrom == 'subCategory' ) _gridBanners(),
            if (widget.getFrom == 'custom')
              StreamBuilder<UnmodifiableListView<CategoryBrands>>(
                  stream: widget.bLoC.allCustomPageBrands,
                  initialData: UnmodifiableListView<CategoryBrands>([]),
                  builder: (context, subCategorySnap) {
                    return subCategorySnap.hasData &&
                            subCategorySnap.data.isNotEmpty
                        ? SizedBox(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: subCategorySnap.data
                                  .map<Widget>(
                                    (i) => SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: i.data
                                              .map<Widget>(
                                                (e) => GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Products(
                                                                      bLoC: widget
                                                                          .bLoC,
                                                                      id: e.id,
                                                                      title: checkLanguage(
                                                                          context,
                                                                          e.arName,
                                                                          e.enName,
                                                                          e.kuName,
                                                                          e.name),
                                                                      getFrom:
                                                                          "brand",
                                                                    )));
                                                  },
                                                  child: Card(
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(5.0),
                                                      child: Container(
                                                        color:
                                                            Color(0xffeff0f4),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5,
                                                                bottom: 5),
                                                        child: Center(
                                                          child: Text(
                                                            checkLanguage(
                                                                context,
                                                                e.arName,
                                                                e.enName,
                                                                e.kuName,
                                                                e.name),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: SizerUtil.deviceType == DeviceType.tablet?16:11,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "sans"),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList()),
                                    ),
                                  )
                                  .toList(),
                            ),
                            height: 40,
                          )
                        : Container();
                  }),
            if (widget.getFrom == 'custom') _customPageGridBanners(),
            StreamBuilder<UnmodifiableListView<Product>>(
                stream: widget.getFrom == 'category'?widget.bLoC.allProductsByFilterCategory:widget.getFrom == 'subCategory'?widget.bLoC.allProductsByFilterSubCategory:widget.getFrom == 'brand'?widget.bLoC.allProductsByFilterBrand:widget.getFrom == 'shop'?widget.bLoC.allProductsByFilterShop:widget.bLoC.allProductsByFilterCategory,
                initialData: UnmodifiableListView<Product>([]),
                builder: (context, snap) {
                  if (snap.data.length > 0 && snap.data.isNotEmpty) {
                    return Stack(
                      children:[
                        Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          chooseCard
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0),
                                  child: GridView.count(
                                    crossAxisCount: SizerUtil.deviceType == DeviceType.tablet?3:2,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    childAspectRatio:
                                    SizerUtil.deviceType == DeviceType.tablet?MediaQuery.of(context).size.width / 1540:MediaQuery.of(context).size.width / 770,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 0.0,
                                    primary: false,
                                    children: snap.data
                                        .map<Widget>((e) => ProductGrid(
                                              product: e,
                                              bLoC: widget.bLoC,
                                            ))
                                        .toList(),
                                  ),
                                )
                              : Column(
                                  children: snap.data
                                      .map<Widget>((e) => ProductList(
                                            product: e,
                                            bLoC: widget.bLoC,
                                          ))
                                      .toList()),

                        ],
                        ),
                        loading ? Container(width:double.infinity,height:100,color:Colors.white,child:loadingGetMore(context, 100.0)) : Container(),
                      ],
                      alignment: Alignment.bottomCenter,

                    );
                  }
                  if (snap.connectionState == ConnectionState.waiting) {
                    return chooseCard
                        ? GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            childAspectRatio:
                                MediaQuery.of(context).size.height / 1440,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 0.0,
                            primary: false,
                            children: List.generate(
                                    10, (e) => loadingProductCard(context))
                                .toList(),
                          )
                        : SingleChildScrollView(
                            child: Column(
                                children: List.generate(10,
                                        (index) => loadingProductList(context))
                                    .toList()),
                          );
                  }
                  return !isLoading
                      ? Padding(
                          padding:
                              const EdgeInsets.only(top: 158.0, bottom: 100),
                          child: Center(
                            child: Text(getTranslated(context, 'no_data')),
                          ),
                        )
                      : chooseCard
                          ? GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              childAspectRatio:
                                  MediaQuery.of(context).size.height / 1440,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 0.0,
                              primary: false,
                              children: List.generate(
                                      10, (e) => loadingProductCard(context))
                                  .toList(),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                  children: List.generate(
                                          10,
                                          (index) =>
                                              loadingProductList(context))
                                      .toList()),
                            );
                }),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigatorBar(
          context, widget.getFrom == 'custom' ? 2 : 0, widget.bLoC, false),
    );
  }

  Widget _gridBanners() {
    return StreamBuilder<UnmodifiableListView<Banners>>(
        stream:  widget.getFrom == 'subCategory'?widget.bLoC.categoryBannersSubCategory:widget.bLoC.categoryBanners,
        initialData: UnmodifiableListView<Banners>([]),
        builder: (context, snap) {
          return snap.hasData && snap.data.isNotEmpty
              ? Column(
                  children: snap.data
                      .map<Widget>((e) => Column(
                            children: [
                              BannerHomeView(
                                e: e,
                                bLoC: widget.bLoC,
                              ),
                              GridBannersView(
                                e: e,
                                bLoC: widget.bLoC,
                              )
                            ],
                          ))
                      .toList())
              : Container();
        });
  }

  // Future<String> refreshData() async {
  //   await widget.bLoC.getProductsByMainCategoryFuture(widget.id);
  //   return 'success';
  // }

  filter() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                StreamBuilder<UnmodifiableListView<CategoryBrands>>(
                    stream: widget.bLoC.allBrandFilter,
                    initialData: UnmodifiableListView<CategoryBrands>([]),
                    builder: (context, snap) {
                      return snap.data.isNotEmpty & snap.hasData
                          ?snap.data[0].data.isNotEmpty ?Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0, bottom: 8, left: 12),
                                  child: Text(
                                    getTranslated(context, "filter_as_brand"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.tablet
                                            ? 8.sp
                                            : 14.sp,
                                        color: Color(0xff404452)),
                                  ),
                                ),
                                SingleChildScrollView(
                                    child: GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount:
                                      SizerUtil.deviceType == DeviceType.tablet
                                          ? 6
                                          : 3,
                                  childAspectRatio: 1.5,
                                  padding: const EdgeInsets.all(4.0),
                                  mainAxisSpacing: 0.0,
                                  crossAxisSpacing: 0.0,
                                  children: snap.data
                                      .map<Widget>(
                                        (i) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              chooseBrand = i.data[0].id.toString();
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  checkLanguage(
                                                      context,
                                                      i.data[0].arName,
                                                      i.data[0].enName,
                                                      i.data[0].kuName,
                                                      i.data[0].name),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: SizerUtil
                                                                  .deviceType ==
                                                              DeviceType.tablet
                                                          ? 6.sp
                                                          : 10.sp,
                                                      color: Colors.black,
                                                      fontWeight: chooseBrand ==
                                                              i.data[0].id.toString()
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      fontFamily: "sans"),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: chooseBrand ==
                                                              i.data[0].id.toString()
                                                          ? Colors.teal[200]
                                                          : Colors.grey[300])),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )),
                              ],
                            )
                          :Container() : Container();
                    }),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<UnmodifiableListView<AllShop>>(
                    stream: widget.bLoC.allShops,
                    initialData: UnmodifiableListView<AllShop>([]),
                    builder: (context, snap) {
                      return snap.data.isNotEmpty & snap.hasData
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0, bottom: 8, left: 12),
                                  child: Text(
                                    getTranslated(context, "filter_as_shop"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.tablet
                                            ? 8.sp
                                            : 14.sp,
                                        color: Color(0xff404452)),
                                  ),
                                ),
                                SingleChildScrollView(
                                    child: GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount:
                                      SizerUtil.deviceType == DeviceType.tablet
                                          ? 6
                                          : 3,
                                  childAspectRatio: 1.5,
                                  padding: const EdgeInsets.all(4.0),
                                  mainAxisSpacing: 0.0,
                                  crossAxisSpacing: 0.0,
                                  children: snap.data
                                      .map<Widget>(
                                        (i) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              chooseShop = i.id.toString();
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  i.name == null ? '' : i.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: SizerUtil
                                                                  .deviceType ==
                                                              DeviceType.tablet
                                                          ? 6.sp
                                                          : 10.sp,
                                                      color: Colors.black,
                                                      fontWeight: chooseShop ==
                                                              i.id.toString()
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      fontFamily: "sans"),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: chooseShop ==
                                                              i.id.toString()
                                                          ? Colors.teal[200]
                                                          : Colors.grey[300])),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )),
                              ],
                            )
                          : Container();
                    }),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<UnmodifiableListView<Attribute>>(
                    stream: widget.bLoC.allAttributes,
                    initialData: UnmodifiableListView<Attribute>([]),
                    builder: (context, snap) {
                      return snap.data.isNotEmpty & snap.hasData
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0, bottom: 8, left: 12),
                                  child: Text(
                                    getTranslated(
                                        context, "filter_as_attributes"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.tablet
                                            ? 8.sp
                                            : 14.sp,
                                        color: Color(0xff404452)),
                                  ),
                                ),
                                SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: snap.data
                                            .map<Widget>(
                                              (e) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12.0,
                                                            bottom: 8,
                                                            left: 12),
                                                    child: Text(
                                                      checkLanguage(
                                                          context,
                                                          e.arTitle,
                                                          e.enTitle,
                                                          e.kuTitle,
                                                          e.title),
                                                      style: TextStyle(
                                                          fontSize: SizerUtil
                                                                      .deviceType ==
                                                                  DeviceType
                                                                      .tablet
                                                              ? 6.sp
                                                              : 12.sp,
                                                          color: Colors.teal),
                                                    ),
                                                  ),
                                                  GridView.count(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    crossAxisCount: SizerUtil
                                                                .deviceType ==
                                                            DeviceType.tablet
                                                        ? 6
                                                        : 3,
                                                    childAspectRatio: 1.5,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    mainAxisSpacing: 0.0,
                                                    crossAxisSpacing: 0.0,
                                                    children: e.values
                                                        .map<Widget>(
                                                          (i) =>
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                chooseAttribute =
                                                                    i;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Container(
                                                                child: Center(
                                                                  child: Text(
                                                                    i,
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize: SizerUtil.deviceType == DeviceType.tablet
                                                                            ? 6
                                                                                .sp
                                                                            : 10
                                                                                .sp,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            "sans",
                                                                        fontWeight: chooseAttribute ==
                                                                                i
                                                                            ? FontWeight.bold
                                                                            : FontWeight.normal),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: chooseAttribute ==
                                                                                i
                                                                            ? Colors.teal[200]
                                                                            : Colors.grey[300])),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList())),
                              ],
                            )
                          : Container();
                    }),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<UnmodifiableListView<dynamic>>(
                    stream: widget.bLoC.allColorsFilter,
                    initialData: UnmodifiableListView<dynamic>([]),
                    builder: (context, snap) {
                      return snap.data.isNotEmpty & snap.hasData
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0, bottom: 8, left: 12),
                                  child: Text(
                                    getTranslated(context, "filter_as_color"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.tablet
                                            ? 8.sp
                                            : 14.sp,
                                        color: Color(0xff404452)),
                                  ),
                                ),
                                SingleChildScrollView(
                                    child: GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount:
                                      SizerUtil.deviceType == DeviceType.tablet
                                          ? 6
                                          : 4,
                                  childAspectRatio: 1.1,
                                  padding: const EdgeInsets.all(4.0),
                                  mainAxisSpacing: 0.0,
                                  crossAxisSpacing: 0.0,
                                  children: snap.data
                                      .map<Widget>(
                                        (i) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              chooseColor = i;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              child: Center(
                                                child: Container(
                                                  color: Color(int.parse(
                                                      i.replaceFirst(
                                                          "#", '0xff'))),
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: chooseColor == i
                                                          ? Colors.teal[200]
                                                          : Colors.grey[300])),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )),
                              ],
                            )
                          : Container();
                    }),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 12.0, bottom: 8, left: 12),
                      child: Text(
                        getTranslated(context, "filter_as_price"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 8.sp
                                : 14.sp,
                            color: Color(0xff404452)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RangeSlider(
                        min: chooseMinPrice,
                        max: chooseMaxPrice,
                        activeColor: color1,
                        inactiveColor:Colors.grey,
                        values: RangeValues(_lowerValue, _upperValue),
                        onChanged: (values) {
                          setState(() {
                            _lowerValue = values.start;
                            _upperValue = values.end;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${_lowerValue.toStringAsFixed(1)}",
                            style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 6.sp
                                        : 10.sp,
                                color: Color(0xff404452)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${_upperValue.toStringAsFixed(1)}",
                            style: TextStyle(
                                fontSize:
                                SizerUtil.deviceType == DeviceType.tablet
                                    ? 6.sp
                                    : 10.sp,
                                color: Color(0xff404452)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 15.w,
                  child: RaisedButton(
                    color: Colors.teal[200],
                    elevation: 0,
                    onPressed: () {
                      checkInternet(context).then((value) async {
                        if (value == 'ok') {
                          setState(() {
                            isLoading = true;
                          });
                          widget.bLoC
                              .getProductsByFilter(
                                  selectedSortType,
                                  chooseShop,
                                  chooseBrand,
                                    chooseCategory,
                                    chooseSubCategory,
                                  chooseColor,
                                  chooseTag,
                                  chooseState,
                                  chooseAttribute,
                                  _lowerValue.toString(),
                                  _upperValue.toString())
                              .then((value) => setState(() {
                                    isLoading = false;
                                  }));
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Text(getTranslated(context, "apply")),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 15.w,
                  child: RaisedButton(
                    color: Colors.grey[300],
                    elevation: 0,
                    onPressed: () {
                      checkInternet(context).then((value) async {
                        if (value == 'ok') {
                          getMaxAndMinPrice(widget.id);
                          getFrom();
                          setState(() {
                            isLoading = true;
                            chooseColor = '';
                            chooseTag = '';
                            chooseState = '';
                            chooseAttribute = '';
                            selectedSortType = 'new_arrival';
                          });
                          widget.bLoC
                              .getProductsByFilter(
                                  selectedSortType,
                                  chooseShop,
                                  chooseBrand,
                                  chooseCategory,
                                  chooseSubCategory,
                                  chooseColor,
                                  chooseTag,
                                  chooseState,
                                  chooseAttribute,
                                  _lowerValue.toString(),
                                  _upperValue.toString())
                              .then((value) => setState(() {
                                    isLoading = false;
                                  }));
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Text(getTranslated(context, "reset")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getMaxAndMinPrice(id) async {
    String url = MAIN_URL + "products/getMaxAndMinPrice/$id";
    Response response = await get(
      Uri.parse(url),
    );
    var data = jsonDecode(response.body);
    if(data['min_price'] !=null && data['max_price'] !=null) {
      if (mounted) {
        setState(() {
          chooseMinPrice = double.parse(data['min_price'].toString());
          chooseMaxPrice = double.parse(data['max_price'].toString());
          _lowerValue = double.parse(data['min_price'].toString());
          _upperValue = double.parse(data['max_price'].toString());
        });
      }
    }
  }

  Widget _customPageGridBanners() {
    return StreamBuilder<UnmodifiableListView<Banners>>(
        stream: widget.bLoC.customPageBanners,
        initialData: UnmodifiableListView<Banners>([]),
        builder: (context, snap) {
          return Column(
              children: snap.data
                  .map<Widget>((e) => Column(
                        children: [
                          BannerHomeView(
                            e: e,
                            bLoC: widget.bLoC,
                          ),
                          GridBannersView(
                            e: e,
                            bLoC: widget.bLoC,
                          )
                        ],
                      ))
                  .toList());
        });
  }
}
