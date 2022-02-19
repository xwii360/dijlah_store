import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
class BannerHomeView extends StatelessWidget {
  final e;
  final BLoC bLoC;
  const BannerHomeView({Key key, this.e, this.bLoC}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return   e.banner1.image==''&&e.banner1.imageEn==''&& e.banner1.imageKu==''?Container():Padding(
      padding:  EdgeInsets.only(top:5.0,bottom: 5,left: 12,right: 12),
      child: GestureDetector(
        onTap: ()=>bannersRedirect(context,bLoC,e.banner1),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: IMAGE_URL + checkLanguageImage(context,e.banner1.image,e.banner1.imageEn,e.banner1.imageKu),
              placeholder: (context, url) =>
              loadingSliderHomePage(
                      context,
                        180.0,
                          MediaQuery.of(context)
                          .size
                          .width),
               errorWidget: (context, url, error) =>
               Icon(Icons.error),
              fit: BoxFit.fill,
              height: 180.0,
              width: MediaQuery.of(context).size.width,
            )),
      ),
    );
  }
}
