import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/shop.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShopCard extends StatelessWidget {
  final BLoC bLoC;
  final AllShop shop;

  const ShopCard({Key key, this.bLoC, this.shop}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Products(bLoC: bLoC,title: shop.name,id: shop.userId,getFrom: "shop",)));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey[300])
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(100.0),
                child: CachedNetworkImage(
                  imageUrl:  IMAGE_URL + shop.logo,
                 placeholder: (context, url) =>
                                                                    loadingSliderHomePage(
                                                                        context,
                                                                     SizerUtil.deviceType == DeviceType.tablet? 10.w:15.w,
                                                                     SizerUtil.deviceType == DeviceType.tablet? 10.w:15.w,),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: SizerUtil.deviceType == DeviceType.tablet? 10.w:15.w,
                  width:SizerUtil.deviceType == DeviceType.tablet? 10.w:15.w,),
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width:SizerUtil.deviceType == DeviceType.tablet? 70.w:70.w,
                    child: Text(
                      shop.name==''?'':shop.name,
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.tablet? 7.sp:13.sp,
                          fontWeight: FontWeight.bold,color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 4,),
                  SizedBox(
                    width:SizerUtil.deviceType == DeviceType.tablet? 70.w:70.w,
                    child: Text(
                      shop.address==''?'':shop.address,
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.tablet? 6.sp:11.sp,
                          color: Colors.grey),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
