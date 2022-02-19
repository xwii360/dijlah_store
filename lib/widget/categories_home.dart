import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class CategoriesHomeView extends StatelessWidget {
  final e;
  final BLoC bLoC;
  const CategoriesHomeView({Key key,this.e,this.bLoC}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Padding(
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
        e.categoryLayout==1?  Padding(
          padding: const EdgeInsets.only(right: 5.0,left: 5),
          child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              childAspectRatio: MediaQuery.of(context).size.height / 1020,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              primary: false,
              children: e.categories.map<Widget>((e) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  Products(
                      bLoC: bLoC,
                      title: checkLanguage(context,e.arName,e.enName,e.kuName,e.name),
                      id: e.id,
                      getFrom: 'category',
                    )));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,
                        height: SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.black, width: 1.3),
                            borderRadius:
                            BorderRadius.circular(100),
                          ),
                          color: Color(0xffdbdce1),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: IMAGE_URL + e.logo,
                              placeholder: (context, url) => ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(100),child: loadingSliderHomePage(context, SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w, SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,)),
                              errorWidget:
                                  (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.contain,
                              width: SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,
                              height: SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: SizerUtil.deviceType == DeviceType.tablet? 14.w:26.w,
                          child: Center(
                            child: Text(checkLanguage(context,e.arName,e.enName,e.kuName,e.name),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:  SizerUtil.deviceType == DeviceType.tablet?5.5.sp:8.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                    ],
                  ),
                );
              }).toList()),
        ):  SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0,left: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: e.categories.map<Widget>((e) {
                    return GestureDetector(
                      onTap: () {
                       Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  Products(
                                  bLoC: bLoC,
                                  title: checkLanguage(context,e.arName,e.enName,e.kuName,e.name),
                                  id: e.id,
                                  getFrom: 'category',
                                )));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,
                            height: SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.black, width: 1.3),
                                borderRadius:
                                BorderRadius.circular(100),
                              ),
                              color: Color(0xffdbdce1),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: IMAGE_URL + e.logo,
                                  placeholder: (context, url) => ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(100),child: loadingSliderHomePage(context, SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w, SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,)),
                                  errorWidget:
                                      (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  width: SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,
                                  height: SizerUtil.deviceType == DeviceType.tablet? 13.w:20.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: SizerUtil.deviceType == DeviceType.tablet? 13.w:23.w,
                              child: Center(
                                child: Text(checkLanguage(context,e.arName,e.enName,e.kuName,e.name),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:  SizerUtil.deviceType == DeviceType.tablet?5.5.sp:8.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
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
