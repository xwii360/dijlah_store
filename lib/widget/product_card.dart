import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/screens/detail_product.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class ProductCard extends StatefulWidget {
  final BLoC bLoC;
  final  Product product;
  const ProductCard({Key key, this.bLoC, this.product}) : super(key: key);
  @override
  _ProductCardState createState() => _ProductCardState();
}
class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  DetailProduct(
                      bLoC: widget.bLoC,
                      product: widget.product,
                    )));
      },
      child: Stack(alignment: Alignment.topLeft, children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: SizerUtil.deviceType == DeviceType.tablet? 26.w:36.w,
            height: SizerUtil.deviceType == DeviceType.tablet? 32.h:30.h,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey[200])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child:         CachedNetworkImage(
                    imageUrl: IMAGE_URL + widget.product.thumbnailImage,
                    placeholder: (context, url) =>loadingSliderHomePage(context, SizerUtil.deviceType == DeviceType.tablet? 20.h:15.h,SizerUtil.deviceType == DeviceType.tablet? 26.w:36.w),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: SizerUtil.deviceType == DeviceType.tablet? 26.w:36.w,
                    height: SizerUtil.deviceType == DeviceType.tablet? 20.h:18.h,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6.0, left: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: SizerUtil.deviceType == DeviceType.tablet? 26.w:36.w,
                          child: Text(checkLanguage(context,widget.product.arabicName,widget.product.enName,widget.product.kuName,widget.product.name),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize:  SizerUtil.deviceType == DeviceType.tablet?7.sp:10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900]),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${widget.product.discount != 0.00 ? double.parse(widget.product.baseDiscountedPrice.toString()).toInt() : widget.product.basePrice} ${getTranslated(context, "short_currency")} ",
                        style: TextStyle(fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:11.sp,color: Colors.grey[800]),
                      ),
                      SizedBox(
                        width: widget.product.discount != 0.00 ? 8 : 0.0,
                      ),
                      widget.product.discount != 0.00
                          ? Text(
                              "${widget.product.basePrice.toString()} ${getTranslated(context, "short_currency")} ",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[500],
                                  fontSize:  SizerUtil.deviceType == DeviceType.tablet?5.sp:9.sp,),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 12,
            left: 10,
            child: widget.product.discount != 0.00
                ? Padding(
              padding:
              const EdgeInsets.only(bottom: 8.0, top: 0),
              child: Container(
                color: Colors.green[50],
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  " ${getTranslated(context, 'sale_off')} ${widget.product.discount}%",
                  style: TextStyle(
                    color: Colors.green[600], fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:10.sp,),
                ),
              ),
            )
                : Container(),)
      ]),
    );
  }
}
