import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/all_brands.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BrandsCard extends StatelessWidget {
  final BLoC bLoC;
  final AllBrand brand;

  const BrandsCard({Key key, this.bLoC, this.brand}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder:
                    (context) =>
                    Products(
                      bLoC: bLoC,
                      id: brand.id,
                      title: checkLanguage(context, brand.arName,brand.enName,brand.kuName,brand.name),
                      getFrom: "brand",
                    )));
      },
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius
                    .circular(
                    0)),
            child: Container(
              color:
              Colors.grey[200],
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
                      brand.logo,
                  placeholder:
                      (context, url) =>
                       loadingSliderHomePage(
                                                                        context,
                           SizerUtil.deviceType == DeviceType.tablet? 10.h:10.h,
                           SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w),
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
            child: Text(checkLanguage(context, brand.arName,brand.enName,brand.kuName,brand.name),
              maxLines: 2,
              overflow:
              TextOverflow
                  .ellipsis,
              style: TextStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.tablet?7.sp:12.sp,
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
    );
  }
}
