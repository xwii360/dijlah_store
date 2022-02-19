import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class BrandHomeView extends StatelessWidget {
  final e;
  final BLoC bLoC;
  const BrandHomeView({Key key, this.e, this.bLoC}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15.0,bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0, bottom: 8,left: 12),
            child: Text(
              checkLanguageImage(context,  e.title[0], e.title[1], e.title[2]),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizerUtil.deviceType == DeviceType.tablet?8.sp:14.sp,
                  color: Color(0xff404452)),
            ),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0,left: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: e.brands.map<Widget>((e) {
                    return GestureDetector(
                      onTap: () {
                       Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
                                    Products(
                                      bLoC: bLoC,
                                      id: e.id,
                                      title:checkLanguage(context,e.arName,e.enName,e.kuName,e.name),getFrom: "brand",
                                    )));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: SizerUtil.deviceType == DeviceType.tablet? 16.w:23.w,
                            height: SizerUtil.deviceType == DeviceType.tablet? 8.h:8.h,
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(
                                //     color: Colors.black, width: 1.3),
                                borderRadius:
                                BorderRadius.circular(5),
                              ),
                              color:Color(0xffedeef0),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(5),
                                child: Padding(
                                  padding:  EdgeInsets.all(SizerUtil.deviceType == DeviceType.tablet?16.0:8),
                                  child: CachedNetworkImage(
                                    imageUrl: IMAGE_URL + e.logo,
                                    placeholder: (context, url) => ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(0),child: loadingSliderHomePage(context,SizerUtil.deviceType == DeviceType.tablet? 8.h:8.h,SizerUtil.deviceType == DeviceType.tablet? 16.w:23.w)),
                                    errorWidget:
                                        (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.contain,
                                    width: SizerUtil.deviceType == DeviceType.tablet? 16.w:23.w,
                                    height: SizerUtil.deviceType == DeviceType.tablet? 8.h:8.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizerUtil.deviceType == DeviceType.tablet? 16.w:23.w,
                            child: Text(checkLanguage(context, e.arName,e.enName,e.kuName,e.name),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:  SizerUtil.deviceType == DeviceType.tablet?5.5.sp:10.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              )),
        ],
      ),
    );
  }
}
