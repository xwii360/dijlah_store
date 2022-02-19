import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SliderHomeView extends StatelessWidget {
  final e;
  final BLoC bLoC;
  const SliderHomeView({Key key, this.e, this.bLoC}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: e.orderingSection==1?EdgeInsets.only(top:10.0,bottom: 10): EdgeInsets.only(top:10.0,bottom: 10,left: 12,right: 12),
      child: CarouselSlider(
        items: [
          if( e.banner1.image!=''||e.banner1.imageEn!=''|| e.banner1.imageKu!='') GestureDetector(
            onTap: ()=>bannersRedirect(context,bLoC,e.banner1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: CachedNetworkImage(
                  imageUrl:
                  IMAGE_URL +  checkLanguageImage(context,e.banner1.image,e.banner1.imageEn,e.banner1.imageKu),
                  placeholder: (context, url) =>
                      loadingSliderHomePage(
                          context,
                          SizerUtil.deviceType ==
                              DeviceType.tablet
                              ?20.h
                              :20.h,
                          MediaQuery.of(context)
                              .size
                              .width),
                  errorWidget:
                      (context, url, error) =>
                      Icon(Icons.error),
                  fit: BoxFit.fill,
                  height: SizerUtil.deviceType ==
                      DeviceType.tablet
                      ?20.h
                      :20.h,
                  width: MediaQuery.of(context)
                      .size
                      .width),
            ),
          ),
          if( e.banner2.image!=''||e.banner2.imageEn!=''|| e.banner2.imageKu!='') GestureDetector(
            onTap: ()=>bannersRedirect(context,bLoC,e.banner2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: CachedNetworkImage(
                  imageUrl:
                  IMAGE_URL + checkLanguageImage(context, e.banner2.image, e.banner2.imageEn,e.banner2.imageKu),
                  placeholder: (context, url) =>
                      loadingSliderHomePage(
                          context,
                          SizerUtil.deviceType ==
                              DeviceType.tablet
                              ?20.h
                              :20.h,
                          MediaQuery.of(context)
                              .size
                              .width),
                  errorWidget:
                      (context, url, error) =>
                      Icon(Icons.error),
                  fit: BoxFit.fill,
                  height: SizerUtil.deviceType ==
                      DeviceType.tablet
                      ?20.h
                      :20.h,
                  width: MediaQuery.of(context)
                      .size
                      .width),
            ),
          ),
          if( e.banner3.image!=''||e.banner3.imageEn!=''|| e.banner3.imageKu!='') GestureDetector(
            onTap: ()=>bannersRedirect(context,bLoC,e.banner3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: CachedNetworkImage(
                  imageUrl:
                  IMAGE_URL + checkLanguageImage(context, e.banner3.image, e.banner3.imageEn,e.banner3.imageKu),
                  placeholder: (context, url) =>
                      loadingSliderHomePage(
                          context,
                          SizerUtil.deviceType ==
                              DeviceType.tablet
                              ?20.h
                              :20.h,
                          MediaQuery.of(context)
                              .size
                              .width),
                  errorWidget:
                      (context, url, error) =>
                      Icon(Icons.error),
                  fit: BoxFit.fill,
                  height: SizerUtil.deviceType ==
                      DeviceType.tablet
                      ?20.h
                      :20.h,
                  width: MediaQuery.of(context)
                      .size
                      .width),
            ),
          ),
          if( e.banner4.image!=''||e.banner4.imageEn!=''|| e.banner4.imageKu!='') GestureDetector(
            onTap: ()=>bannersRedirect(context,bLoC,e.banner4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: CachedNetworkImage(
                  imageUrl:
                  IMAGE_URL + checkLanguageImage(context, e.banner4.image, e.banner4.imageEn,e.banner4.imageKu),
                  placeholder: (context, url) =>
                      loadingSliderHomePage(
                          context,
                          SizerUtil.deviceType ==
                              DeviceType.tablet
                              ?20.h
                              :20.h,
                          MediaQuery.of(context)
                              .size
                              .width),
                  errorWidget:
                      (context, url, error) =>
                      Icon(Icons.error),
                  fit: BoxFit.fill,
                  height: SizerUtil.deviceType ==
                      DeviceType.tablet
                      ?20.h
                      :20.h,
                  width: MediaQuery.of(context)
                      .size
                      .width),
            ),
          ),

         if(e.banner5.image!=''|| e.banner5.imageEn!='' || e.banner5.imageKu!='')  GestureDetector(
            onTap: ()=>bannersRedirect(context,bLoC,e.banner5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: CachedNetworkImage(
                  imageUrl:
                  IMAGE_URL + checkLanguageImage(context, e.banner5.image, e.banner5.imageEn,e.banner5.imageKu),
                  placeholder: (context, url) =>
                      loadingSliderHomePage(
                          context,
                          SizerUtil.deviceType ==
                              DeviceType.tablet
                              ?20.h
                              :20.h,
                          MediaQuery.of(context)
                              .size
                              .width),
                  errorWidget:
                      (context, url, error) =>
                      Icon(Icons.error),
                  fit: BoxFit.fill,
                  height: SizerUtil.deviceType ==
                      DeviceType.tablet
                      ?20.h
                      :20.h,
                  width: MediaQuery.of(context)
                      .size
                      .width),
            ),
          ),
        ],
        options: CarouselOptions(
          height:
          SizerUtil.deviceType == DeviceType.tablet
              ?20.h
              :20.h,
          aspectRatio: 16 / 9,
          viewportFraction: 1.0,
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration:
          Duration(milliseconds: 2000),
          autoPlayCurve: Curves.ease,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
