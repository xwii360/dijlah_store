import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/category.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:dijlah_store_ibtechiq/widget/banner_home.dart';
import 'package:dijlah_store_ibtechiq/widget/grid_banner_home.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class Categories extends StatefulWidget {
  final BLoC bLoC;
  const Categories({Key key, this.bLoC}) : super(key: key);
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var indexCategory;
  var indexTitle;
  bool showInitData = true;
  int index=0;

  bool showLoading=true;

  void initState() {
    checkInternet(context);
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (this.mounted) {
        setState(() {
           showLoading=false;
        });
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (this.mounted) {
        setState(() {
          showInitData = false;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: appBarTitle(getTranslated(context, "all_category_title")),
        titleSpacing: 0.0,
        leading: backArrow(context),
        centerTitle: false,
        // actions: [
        //   FlatButton(
        //     child: Text(
        //       getTranslated(
        //         context,
        //         "all_products_title",
        //       ),
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontWeight: FontWeight.normal,
        //         fontSize:
        //             SizerUtil.deviceType == DeviceType.tablet ? 7.sp : 13.sp,
        //       ),
        //     ),
        //     onPressed: () {
        //      Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  Products(
        //                     bLoC: widget.bLoC,
        //                     title: indexTitle,
        //                     id: indexCategory,
        //                    getFrom: 'category',
        //                   )));
        //     },
        //   )
        // ],
      ),
      body: StreamBuilder<UnmodifiableListView<AllCategory>>(
          stream: widget.bLoC.allCategories,
          initialData: UnmodifiableListView<AllCategory>([]),
          builder: (context, snap) {
            snap.hasData && snap.data.isNotEmpty
                ? showInitData
                    ? indexCategory = snap.data[0].id
                    : Container()
                : Container();
            snap.hasData && snap.data.isNotEmpty
                ? showInitData
                    ? indexTitle = checkLanguage(context,snap.data[0].arName,snap.data[0].enName,snap.data[0].kuName,snap.data[0].name)
                    : Container()
                : Container();
            return  snap.hasData && snap.data.isNotEmpty
                ? Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex:  SizerUtil.deviceType == DeviceType.tablet ?2:3,
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.grey[200],
                        height: SizerUtil.deviceType == DeviceType.tablet
                            ? MediaQuery.of(context).size.height*snap.data.length/20
                            : MediaQuery.of(context).size.height*snap.data.length/15,
                        width:
                            SizerUtil.deviceType == DeviceType.tablet ? 18.w : 25.w,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Column(
                                children: snap.data
                                    .map((e) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showInitData = false;
                                              indexCategory = e.id;
                                              indexTitle = checkLanguage(context,e.arName,e.enName,e.kuName,e.name);
                                              index=snap.data.indexOf(e);
                                            });
                                          },
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            elevation: 0,
                                            color: indexCategory == e.id
                                                ? Colors.white
                                                : Colors.grey[200],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(0.0),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12,
                                                    right: 12,
                                                    bottom: 8,
                                                    top: 15),
                                                child: Text(
                                                  checkLanguage(context,e.arName,e.enName,e.kuName,e.name),
                                                  style: TextStyle(
                                                      fontSize: SizerUtil.deviceType ==
                                                              DeviceType.tablet
                                                          ? 6.sp
                                                          : 10.sp,
                                                      fontWeight: indexCategory == e.id
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      color: indexCategory == e.id
                                                          ? Colors.teal[300]
                                                          : Colors.black),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                           //   SizedBox(height: MediaQuery.of(context).size.width,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      snap.data[index].banners.isNotEmpty&& (snap.data[index].banners[0].banner1.image!=''||snap.data[index].banners[0].banner1.imageEn!=''||snap.data[index].banners[0].banner1.imageKu!='')? BannerHomeView(e:snap.data[index].banners[0],bLoC: widget.bLoC,):Container(),
                                      snap.data[index].banners.isNotEmpty&& (snap.data[index].banners[0].banner2.image!=''||snap.data[index].banners[0].banner2.imageEn!=''||snap.data[index].banners[0].banner2.imageKu!='')?  GridBannersView(e:snap.data[index].banners[0],bLoC: widget.bLoC,):Container(),
                                     if( snap.data[index].subCategories.data.isNotEmpty )  Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0,
                                            right: 12,
                                            bottom: 8,
                                            top: 16),
                                        child: Text(
                                          getTranslated(
                                              context, "sub_category_title"),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: SizerUtil.deviceType == DeviceType.tablet ? 7.sp : 12.sp,
                                              color: Color(0xff404452)),
                                        ),
                                      ),
                                      if( snap.data[index].subCategories.data.isNotEmpty )   SizedBox(
                                        child: GridView.count(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          crossAxisCount: SizerUtil.deviceType == DeviceType.tablet ?4:3,
                                          childAspectRatio: SizerUtil.deviceType == DeviceType.tablet ?0.99:0.77,
                                          padding: const EdgeInsets.all(4.0),
                                          mainAxisSpacing: 0.0,
                                          crossAxisSpacing: 0.0,
                                          children: snap.data[index].subCategories.data
                                              .map(
                                                (i) => GestureDetector(
                                                  onTap: () {
                                                   Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
                                                                Products(
                                                                  bLoC: widget.bLoC,
                                                                  id: i.id,
                                                                  title: checkLanguage(context,i.arName,i.enName,i.kuName,i.name),
                                                                  getFrom: "subCategory",
                                                                )));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0)),
                                                        child: Container(
                                                          color: Colors.grey[100],
                                                          height: SizerUtil.deviceType == DeviceType.tablet? 10.h:8.h,
                                                          width:SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6.0),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: IMAGE_URL +
                                                                          i
                                                                              .banner ==
                                                                      ""
                                                                  ? IMAGE_URL +
                                                                      i.icon
                                                                  : IMAGE_URL +
                                                                      i.banner,
                                                                  placeholder: (context, url) =>
                                                                      loadingSliderHomePage(
                                                                          context,
                                                                       SizerUtil.deviceType == DeviceType.tablet? 10.h:8.h,
                                                                       SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,),
                                                              errorWidget: (context,
                                                                      url, error) =>
                                                                  Icon(Icons.error),
                                                              fit: BoxFit.fill,
                                                                  height: SizerUtil.deviceType == DeviceType.tablet? 10.h:8.h,
                                                                  width:SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                                                            ),
                                                          ),
                                                        ),
                                                        elevation: 0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 0.0),
                                                        child: Text(
                                                          checkLanguage(context,i.arName,i.enName,i.kuName,i.name),
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontSize: SizerUtil.deviceType == DeviceType.tablet ? 6.sp : 10.sp,
                                                              color: Colors.black,
                                                              fontFamily: "sans"),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                        width: SizerUtil.deviceType ==
                                            DeviceType.tablet
                                            ? 81.w
                                            : 73.w,
                                      ),
                                      snap.data[index].brands.isNotEmpty?   Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 12.0,
                                                                right: 12,
                                                                bottom: 8,
                                                                top: 16),
                                                        child: Text(
                                                          getTranslated(context,
                                                              "best_brand"),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize:SizerUtil.deviceType == DeviceType.tablet ? 8.sp : 12.sp,
                                                              color: Color(
                                                                  0xff404452)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        child: GridView.count(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          crossAxisCount: SizerUtil.deviceType == DeviceType.tablet ?4:3,
                                                          childAspectRatio: SizerUtil.deviceType == DeviceType.tablet ?0.99:0.72,
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  4.0),
                                                          mainAxisSpacing: 0.0,
                                                          crossAxisSpacing: 0.0,
                                                          children: snap.data[index].brands
                                                              .map<Widget>(
                                                                (i) =>
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                   Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
                                                                                Products(
                                                                                  bLoC: widget.bLoC,
                                                                                  id: i['id'],
                                                                                  title:checkLanguage(context,i['ar_name'],i['en_name'],i['ku_name'],i['name']),
                                                                                  getFrom: "brand",
                                                                                )));
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      Card(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(0)),
                                                                        child:
                                                                            Container(
                                                                          color: Colors
                                                                                  .grey[
                                                                              100],
                                                                              height: SizerUtil.deviceType == DeviceType.tablet? 10.h:8.h,
                                                                              width:SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(16.0),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              imageUrl:
                                                                                  IMAGE_URL + i['logo'],
                                                                                  placeholder: (context, url) =>
                                                                                      loadingSliderHomePage(
                                                                                          context,
                                                                                      SizerUtil.deviceType == DeviceType.tablet? 10.h:8.h,
                                                                                       SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,),
                                                                              errorWidget: (context, url, error) =>
                                                                                  Icon(Icons.error),
                                                                              fit: BoxFit
                                                                                  .contain,
                                                                                  height: SizerUtil.deviceType == DeviceType.tablet? 10.h:8.h,
                                                                                  width:SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        elevation:
                                                                            0,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                                .only(
                                                                            top:
                                                                                0.0),
                                                                        child: Text(
                                                                    checkLanguage(context,i['ar_name'],i['en_name'],i['ku_name'],i['name']),
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow
                                                                                  .ellipsis,
                                                                          style: TextStyle(
                                                                              fontSize: SizerUtil.deviceType == DeviceType.tablet ? 6.sp : 10.sp,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontFamily:
                                                                                  "sans"),
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                        ),
                                                        width:SizerUtil.deviceType == DeviceType.tablet? 80.w:74.w,
                                                      ),
                                                    ],
                                                  ):Container()
                                    ],
                                  ),
                  ),
                )
                ],
              ),
            ):showLoading?Container(
              child: Center(
                child: Text(getTranslated(context, 'loading')),
              ),
            ):Container(
              child: Center(
                child: Text(getTranslated(context, 'no_data')),
              ),
            );
          }),
      bottomNavigationBar: bottomNavigatorBar(context, 1, widget.bLoC, false),
    );
  }

}
