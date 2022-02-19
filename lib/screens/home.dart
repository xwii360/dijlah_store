import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/home_sections.dart';
import 'package:dijlah_store_ibtechiq/screens/flash_deal_slider.dart';
import 'package:dijlah_store_ibtechiq/screens/search.dart';
import 'package:dijlah_store_ibtechiq/widget/banner_home.dart';
import 'package:dijlah_store_ibtechiq/widget/brands_home.dart';
import 'package:dijlah_store_ibtechiq/widget/categories_home.dart';
import 'package:dijlah_store_ibtechiq/widget/grid_banner_home.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:dijlah_store_ibtechiq/widget/products_home.dart';
import 'package:dijlah_store_ibtechiq/widget/shops_home.dart';
import 'package:dijlah_store_ibtechiq/widget/slider_home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class HomeScreen extends StatefulWidget {
  final BLoC bLoC;
  const HomeScreen({Key key, this.bLoC}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Timer timer;
  bool _visibleList = true;

  @override
  void initState() {
    super.initState();
    checkInternet(context);
    widget.bLoC.getAllWishListFuture();
    widget.bLoC.getCartItemFuture();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => alert(context),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 20),
            child: Image(
                image: AssetImage("assets/top_bar_logo.png"),
                width:
                    SizerUtil.deviceType == DeviceType.tablet ? 25.w : 45.w,
                height:
                    SizerUtil.deviceType == DeviceType.tablet ? 25.h : 45.h),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(
                SizerUtil.deviceType == DeviceType.tablet ? 100.w : 100.w,
                SizerUtil.deviceType == DeviceType.tablet ? 7.h : 9.h),
            child: Column(
              children: [
                SizedBox(
                  width:
                      SizerUtil.deviceType == DeviceType.tablet ? 99.w : 98.w,
                  height: SizerUtil.deviceType == DeviceType.tablet
                      ? 5.2.h
                      : 6.5.h,
                  child: Card(
                    elevation: 0,
                    color: Color(0xffedeef0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      autofocus: false,
                      autocorrect: false,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      onTap: () {
                       Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  Search(
                                      bLoC: widget.bLoC,
                                    )));
                      },
                      readOnly: true,
                      decoration: new InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded,
                              size: SizerUtil.deviceType == DeviceType.tablet
                                  ? 35
                                  : 24,
                              color: Color(0xffa0a4b3)),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(20.0,  SizerUtil.deviceType == DeviceType.tablet
                              ?16:14.0, 20.0, 15.0),
                          hintText: getTranslated(context, "search_hint"),
                          hintStyle: TextStyle(
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 18
                                      : 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffa0a4b3))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlashDealSlider(bLoC: widget.bLoC,),
              _productList()
            ],
          ),
        ),
        bottomNavigationBar:
            bottomNavigatorBar(context, 0, widget.bLoC, true),
      ),
    );
  }

  Widget _productList() {
    return StreamBuilder<UnmodifiableListView<HomeSections>>(
        stream: widget.bLoC.homeSections,
        initialData: UnmodifiableListView<HomeSections>([]),
        builder: (context, snap) {
          return snap.hasData && snap.data.isNotEmpty
              ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
                  children: snap.data.map((e) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      e.sectionType==5?ShopsHomeView(e: e,bLoC: widget.bLoC,):Container(),
                      e.sectionType==4?CategoriesHomeView(e: e,bLoC: widget.bLoC,):Container(),
                      e.sectionType==6?BrandHomeView(e: e,bLoC: widget.bLoC,):Container(),
                      e.sectionType == 0
                          ? BannerHomeView(e: e,bLoC: widget.bLoC,)
                          : Container(),
                      e.sectionType==1?GridBannersView(e:e,bLoC: widget.bLoC,):Container(),
                      e.sectionType==2? ProductsHomeView(e:e,bLoC: widget.bLoC,):Container(),
                      e.sectionType == 3
                          ? SliderHomeView(e: e,bLoC: widget.bLoC,)
                          : Container()
                    ],
                  );
                }).toList())
              :  Column(
                children: [
                  Visibility(
            visible: snap.data.isNotEmpty ? false :_visibleList,
                    child: Column(
                      children: [
                        loadingBanner(context),
                        SizedBox(height: 10,),
                        loadingGridBanner(context),
                        SizedBox(height: 10,),
                        loadingProductCardList(context),
                        SizedBox(height: 10,),
                        loadingBanner(context),
                        SizedBox(height: 10,),
                        loadingGridBanner(context),
                        SizedBox(height: 10,),
                        loadingProductCardList(context),
                        SizedBox(height: 10,),
                        loadingProductCardList(context),
                        SizedBox(height: 10,),
                        loadingProductCardList(context),
                      ],
                    ),
                  ),
                ],
              );
        });
  }
}
