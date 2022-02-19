import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/all_brands.dart';
import 'package:dijlah_store_ibtechiq/model/category.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:dijlah_store_ibtechiq/widget/products_list.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class EmptySearchItems extends StatelessWidget {
  final BLoC bLoC;

  const EmptySearchItems({Key key, this.bLoC}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<UnmodifiableListView<AllCategory>>(
              stream: bLoC.allCategories,
              initialData: UnmodifiableListView<AllCategory>([]),
              builder: (context, snap) {
                return snap.hasData && snap.data.isNotEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:18.0,top: 20,bottom: 10,left: 18),
                          child: Text(getTranslated(context, "choose_for_you"),style: navBarHeaderStyle2,),
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          physics:
                          NeverScrollableScrollPhysics(),
                          crossAxisCount: SizerUtil.deviceType == DeviceType.tablet?5:3,
                          childAspectRatio: SizerUtil.deviceType == DeviceType.tablet?0.89:0.80,
                          padding:
                          const EdgeInsets.all(4.0),
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          children: snap.data.take(10)
                              .map(
                                (i) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            Products(
                                              bLoC: bLoC,
                                              id: i.id,
                                              title: checkLanguage(context,i.arName,i.enName,i.kuName,i.name),
                                              getFrom: 'category',
                                            )));
                              },
                              child: Column(
                                children: [
                                  Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              5),
                                        color:
                                        Colors.grey[200],
                                      ),

                                      height: SizerUtil.deviceType == DeviceType.tablet? 12.h:12.h,
                                      width:SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            16.0),
                                        child:
                                        CachedNetworkImage(
                                          imageUrl:
                                          IMAGE_URL +
                                              i
                                                  .banner ==
                                              ""
                                              ? IMAGE_URL +
                                              i.icon
                                              : IMAGE_URL +
                                              i.banner,
                                          placeholder:
                                              (context, url) =>
                                               loadingSliderHomePage(
                                                                        context,
                                                   SizerUtil.deviceType == DeviceType.tablet? 10.h:10.h,
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .width),
                                          errorWidget: (context,
                                              url,
                                              error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit
                                              .fill,
                                          height: SizerUtil.deviceType == DeviceType.tablet? 10.h:10.h,
                                          width:SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                                        ),
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets
                                        .only(
                                        top: 0.0),
                                    child: Text(
                                      checkLanguage(context,i.arName,i.enName,i.kuName,i.name),
                                      maxLines: 2,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style: TextStyle(
                                          fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:11.sp,
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
                        )
                      ],
                    )
                    : Container();
              }),
          StreamBuilder<UnmodifiableListView<AllBrand>>(
              stream: bLoC.allBrands,
              initialData: UnmodifiableListView<AllBrand>([]),
              builder: (context, snap) {
                return snap.hasData && snap.data.isNotEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:18.0,top: 20,bottom: 10,left: 18),
                          child: Text(getTranslated(context, "suggest_some_brands"),style: navBarHeaderStyle2,),
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          physics:
                          NeverScrollableScrollPhysics(),
                          crossAxisCount: SizerUtil.deviceType == DeviceType.tablet?5:3,
                          childAspectRatio:SizerUtil.deviceType == DeviceType.tablet?0.89: 0.80,
                          padding:
                          const EdgeInsets.all(4.0),
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          children: snap.data.take(10)
                              .map(
                                (i) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            Products(
                                              bLoC: bLoC,
                                              id: i.id,
                                              title: checkLanguage(context,i.arName,i.enName,i.kuName,i.name),
                                              getFrom: "brand",
                                            )));
                              },
                              child: Column(
                                children: [
                                  Card(
                                    child: Container(
                              decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(
                              5),
                                  color:
                                  Colors.grey[200],
                                ),
                                      height: SizerUtil.deviceType == DeviceType.tablet? 12.h:12.h,
                                      width:SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            16.0),
                                        child:
                                        CachedNetworkImage(
                                          imageUrl:
                                          IMAGE_URL +
                                              i
                                                  .logo,
                                          placeholder:
                                              (context, url) =>
                                               loadingSliderHomePage(
                                                                        context,
                                                   SizerUtil.deviceType == DeviceType.tablet? 10.h:10.h,
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .width),
                                          errorWidget: (context,
                                              url,
                                              error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit
                                              .contain,
                                          height: SizerUtil.deviceType == DeviceType.tablet? 10.h:10.h,
                                          width:SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                                        ),
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets
                                        .only(
                                        top: 0.0),
                                    child: Text(
                                      checkLanguage(context,i.arName,i.enName,i.kuName,i.name),
                                      maxLines: 2,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style: TextStyle(
                                          fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:11.sp,
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
                        )
                      ],
                    )
                    : Container();
              }),
          StreamBuilder<UnmodifiableListView<Product>>(
              stream:bLoC.allProducts,
              initialData: UnmodifiableListView<Product>([]),
              builder: (context, snap) {
                return snap.data.isNotEmpty&& snap.hasData?Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:18.0,top: 20,bottom: 10,left: 18),
                      child: Text(getTranslated(context, "see_newest_products"),style: navBarHeaderStyle2,),
                    ),
                    Column(
                        children: snap.data.take(6)
                            .map((e) => ProductList(product: e, bLoC:bLoC,))
                            .toList()),
                  ],
                ):Container();
              }),
        ],
      ),
    );
  }
}
