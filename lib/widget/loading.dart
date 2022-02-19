import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
Widget loadingSliderHomePage(context,height,width) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(0),
    child: Shimmer.fromColors(
      enabled: true,
      baseColor: Color(0xffeeedf2),
      highlightColor: Colors.white,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(0),
          child: Container(
            width: width,
            height: height,
          ),
        ),
        elevation: 0,
      ),
    ),
  );
}
Widget loadingCategoryHomePage(context) {
  return Shimmer.fromColors(
    enabled: true,
    baseColor: Color(0xffeeedf2),
    highlightColor: Colors.white,
    child: Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: Container(
            height: 75.0,
            width: 75.0,
            alignment: Alignment.center,
          ),
        ),
        Container(
          width: 60,
          height: 13,
          decoration: BoxDecoration(
              color: Color(0xffeeedf2),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ],
    ),
  );
}
Widget loadingBrandHomePage(context) {
  return Shimmer.fromColors(
    enabled: true,
    baseColor: Color(0xffeeedf2),
    highlightColor: Colors.white,
    child: Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Container(
            width: SizerUtil.deviceType == DeviceType.tablet? 16.w:26.w,
            height: SizerUtil.deviceType == DeviceType.tablet? 7.h:7.h,
            alignment: Alignment.center,
          ),
        ),
        Container(
          width: SizerUtil.deviceType == DeviceType.tablet? 16.w:24.w,
          height: 13,
          decoration: BoxDecoration(
              color: Color(0xffeeedf2),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ],
    ),
  );
}
Widget loadingMainTitleHomePage(context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Shimmer.fromColors(
      enabled: true,
      baseColor: Color(0xffeeedf2),
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                  color: Color(0xffeeedf2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            Container(
              width: 50,
              height: 20,
              decoration: BoxDecoration(
                  color: Color(0xffeeedf2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget loadingProductCard(context) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      height: MediaQuery.of(context).size.height / 2.6,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration:
      BoxDecoration(border: Border.all(color: Colors.grey[200])),
      child: Shimmer.fromColors(
        enabled: true,
        baseColor: Color(0xffeeedf2),
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: SizerUtil.deviceType == DeviceType.tablet
                      ?MediaQuery.of(context).size.width / 4.3:MediaQuery.of(context).size.width / 2.3,
                  height: SizerUtil.deviceType == DeviceType.tablet
                      ?MediaQuery.of(context).size.width / 4.0:MediaQuery.of(context).size.width / 2.0,
                  decoration: BoxDecoration(
                      color: Color(0xffeeedf2),
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: SizerUtil.deviceType == DeviceType.tablet
                    ?MediaQuery.of(context).size.width / 4.3:MediaQuery.of(context).size.width / 2.3,
                height: SizerUtil.deviceType == DeviceType.tablet
                    ?40:20,
                decoration: BoxDecoration(
                    color: Color(0xffeeedf2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              SizedBox(height: 8,),
              Container(
                width: SizerUtil.deviceType == DeviceType.tablet
                    ?MediaQuery.of(context).size.width / 4.3:MediaQuery.of(context).size.width / 2.3,
                height: SizerUtil.deviceType == DeviceType.tablet
                    ?40:20,
                decoration: BoxDecoration(
                    color: Color(0xffeeedf2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
loadingBanner(context){
  return  Container(
    child: loadingSliderHomePage(context, 130.0,  MediaQuery.of(context)
        .size
        .width),
  );
}
loadingProductCardList(context){
  return  Column(
    children: [
      loadingMainTitleHomePage(context),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
            List.generate(10, (e) => loadingProductCard(context))
                .toList(),
          ),
        ),
      ),
    ],
  );
}
loadingGridBanner(context){
  return  GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: MediaQuery.of(context).size.height / 430,
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 5,
      primary: false,
      children:[
        Container(
          child: loadingSliderHomePage(context, 130.0,  MediaQuery.of(context)
              .size
              .width),
        ),
        Container(
          child: loadingSliderHomePage(context, 130.0,  MediaQuery.of(context)
              .size
              .width),
        ),
        Container(
          child: loadingSliderHomePage(context, 130.0,  MediaQuery.of(context)
              .size
              .width),
        ),
        Container(
          child: loadingSliderHomePage(context, 130.0,  MediaQuery.of(context)
              .size
              .width),
        ),
      ]);
}
Widget loadingProductList(context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Shimmer.fromColors(
          enabled: true,
          baseColor: Color(0xffeeedf2),
          highlightColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Color(0xffeeedf2),
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Color(0xffeeedf2),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Color(0xffeeedf2),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left:0, right: 0),
        child: Divider(
          height: 0,
          thickness: 1,
          color: Colors.grey[200],
        ),
      )
    ],
  );
}

Widget loadingCategory(context) {
  return Shimmer.fromColors(
    enabled: true,
    baseColor: Color(0xffeeedf2),
    highlightColor: Colors.white,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 175,
        height: 175,
        alignment: Alignment.center,
      ),
    ),
  );
}
Widget loadingShopList(context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Shimmer.fromColors(
          enabled: true,
          baseColor: Color(0xffeeedf2),
          highlightColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                      width:  60,
                      height: 60,
                    decoration: BoxDecoration(
                        color: Color(0xffeeedf2),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Color(0xffeeedf2),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 12,
                      decoration: BoxDecoration(
                          color: Color(0xffeeedf2),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left:0, right: 0),
        child: Divider(
          height: 0,
          thickness: 1,
          color: Colors.grey[200],
        ),
      )
    ],
  );
}
Widget loadingBrand(context) {
  return Shimmer.fromColors(
    enabled: true,
    baseColor: Color(0xffeeedf2),
    highlightColor: Colors.white,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 175,
        height: 175,
        alignment: Alignment.center,
      ),
    ),
  );
}

Widget loadingCart(context) {
  return Column(
    children: [
      Shimmer.fromColors(
        enabled: true,
        baseColor: Color(0xffeeedf2),
        highlightColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 15,
                    decoration: BoxDecoration(
                        color: Color(0xffeeedf2),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 15,
                    decoration: BoxDecoration(
                        color: Color(0xffeeedf2),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ],
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                width: 75,
                height: 75,
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 10,),
      Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: 15,
            decoration: BoxDecoration(
                color: Color(0xffeeedf2),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          SizedBox(width: 20,),
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: 15,
            decoration: BoxDecoration(
                color: Color(0xffeeedf2),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Padding(
        padding: const EdgeInsets.only(left:0, right: 0),
        child: Divider(
          height: 0,
          thickness: 1,
          color: Colors.grey[200],
        ),
      )
    ],
  );
}


