import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class GridBannersView extends StatelessWidget {
  final e;
  final BLoC bLoC;
  const GridBannersView({Key key, this.e, this.bLoC}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:5.0,bottom: 5,right: 12,left: 12),
      child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: MediaQuery.of(context).size.height / 600,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          primary: false,
          children:[
            if( e.banner2.image!=''||e.banner2.imageEn!=''|| e.banner2.imageKu!='') GestureDetector(
              onTap: ()=>bannersRedirect(context,bLoC,e.banner2),
              child: ClipRRect(
                borderRadius: BorderRadius. circular(5),
                child: CachedNetworkImage(
                    imageUrl:
                    IMAGE_URL + checkLanguageImage(context,e.banner2.image,e.banner2.imageEn,e.banner2.imageKu),
                    placeholder: (context, url) =>
                        loadingSliderHomePage(
                            context,
                            SizerUtil.deviceType ==
                                DeviceType.tablet
                                ? 26.h
                                : 26.h,
                            MediaQuery.of(context)
                                .size
                                .width),
                    errorWidget:
                        (context, url, error) =>
                        Icon(Icons.error),
                    fit: BoxFit.fill,
                    height: SizerUtil.deviceType ==
                        DeviceType.tablet
                        ? 26.h
                        : 26.h,
                    width: MediaQuery.of(context)
                        .size
                        .width),
              ),
            ),
            if( e.banner3.image!=''||e.banner3.imageEn!=''|| e.banner3.imageKu!='') GestureDetector(
              onTap: () => bannersRedirect(context,bLoC,e.banner3),
              child: ClipRRect(
                borderRadius: BorderRadius. circular(5),
                child: CachedNetworkImage(
                    imageUrl:
                    IMAGE_URL + checkLanguageImage(context,  e.banner3.image, e.banner3.imageEn, e.banner3.imageKu),
                    placeholder: (context, url) =>
                        loadingSliderHomePage(
                            context,
                            SizerUtil.deviceType ==
                                DeviceType.tablet
                                ? 26.h
                                : 26.h,
                            MediaQuery.of(context)
                                .size
                                .width),
                    errorWidget:
                        (context, url, error) =>
                        Icon(Icons.error),
                    fit: BoxFit.fill,
                    height: SizerUtil.deviceType ==
                        DeviceType.tablet
                        ? 26.h
                        : 26.h,
                    width: MediaQuery.of(context)
                        .size
                        .width),
              ),
            ),
            if( e.banner4.image!=''||e.banner4.imageEn!=''|| e.banner4.imageKu!='') GestureDetector(
              onTap: () => bannersRedirect(context,bLoC,e.banner4),
              child: ClipRRect(
                borderRadius: BorderRadius. circular(5),
                child: CachedNetworkImage(
                    imageUrl:
                    IMAGE_URL + checkLanguageImage(context,  e.banner4.image, e.banner4.imageEn, e.banner4.imageKu),
                    placeholder: (context, url) =>
                        loadingSliderHomePage(
                            context,
                            SizerUtil.deviceType ==
                                DeviceType.tablet
                                ? 26.h
                                : 26.h,
                            MediaQuery.of(context)
                                .size
                                .width),
                    errorWidget:
                        (context, url, error) =>
                        Icon(Icons.error),
                    fit: BoxFit.fill,
                    height: SizerUtil.deviceType ==
                        DeviceType.tablet
                        ? 26.h
                        : 26.h,
                    width: MediaQuery.of(context)
                        .size
                        .width),
              ),
            ),
            if( e.banner5.image!=''||e.banner5.imageEn!=''|| e.banner5.imageKu!='')  GestureDetector(
              onTap: ()=> bannersRedirect(context,bLoC,e.banner5),
              child: ClipRRect(
                borderRadius: BorderRadius. circular(5),
                child: CachedNetworkImage(
                    imageUrl:
                    IMAGE_URL + checkLanguageImage(context,  e.banner5.image, e.banner5.imageEn, e.banner5.imageKu),
                    placeholder: (context, url) =>
                        loadingSliderHomePage(
                            context,
                            SizerUtil.deviceType ==
                                DeviceType.tablet
                                ? 26.h
                                : 26.h,
                            MediaQuery.of(context)
                                .size
                                .width),
                    errorWidget:
                        (context, url, error) =>
                        Icon(Icons.error),
                    fit: BoxFit.fill,
                    height: SizerUtil.deviceType ==
                        DeviceType.tablet
                        ? 26.h
                        : 26.h,
                    width: MediaQuery.of(context)
                        .size
                        .width),
              ),
            ),
          ]),
    );
  }
}
