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
class ProductList extends StatefulWidget {
  final BLoC bLoC;
  final Product product;
  const ProductList({Key key, this.bLoC, this.product}) : super(key: key);
  @override
  _ProductListState createState() => _ProductListState();
}
class _ProductListState extends State<ProductList> {
  var attributes;
  String color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  DetailProduct(
                      bLoC: widget.bLoC,
                      product: widget.product,
                    )));
      },
      child: Stack(
        children: [
         Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                   borderRadius: BorderRadius.circular(10),
                   child:
                   CachedNetworkImage(
                     imageUrl: IMAGE_URL + widget.product.thumbnailImage,
                    placeholder: (context, url) =>
                                                                    loadingSliderHomePage(
                                                                        context,
                                                                        SizerUtil.deviceType == DeviceType.tablet? 20.h:18.h,
                                                                        SizerUtil.deviceType == DeviceType.tablet? 30.w:30.w),
                     errorWidget: (context, url, error) => Icon(Icons.error),
                     fit: BoxFit.contain,
                     height: SizerUtil.deviceType == DeviceType.tablet? 20.h:18.h,
                     width: SizerUtil.deviceType == DeviceType.tablet? 30.w:30.w,
                   )
                    ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height:SizerUtil.deviceType == DeviceType.tablet?35:15,),
                      SizedBox(
                          width: SizerUtil.deviceType == DeviceType.tablet? 65.w:60.w,
                          child: Text(
                                 checkLanguage(context,widget.product.arabicName,widget.product.enName,widget.product.kuName,widget.product.name),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,fontSize:  SizerUtil.deviceType == DeviceType.tablet?8.sp:13.sp,color: Colors.grey[900],),maxLines: 3,overflow: TextOverflow.ellipsis,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${widget.product.discount != 0.00 ? double.parse(widget.product.baseDiscountedPrice.toString()).toInt() : widget.product.basePrice} ${getTranslated(context, "short_currency")} ",
                            style: TextStyle(fontSize:  SizerUtil.deviceType == DeviceType.tablet?7.sp:12.sp, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          widget.product.discount != 0.00 ? Text(
                                  "${widget.product.basePrice.toString()} ${getTranslated(context, "short_currency")} ",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[600],
                                      fontSize: SizerUtil.deviceType == DeviceType.tablet?7.sp:11.sp),
                                )
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      widget.product.discount != 0.00
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.green[50],
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: Text(
                            " ${getTranslated(context, 'sale_off')} ${widget.product.discount}%",
                            style: TextStyle(
                                color: Colors.green[600],
                                fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:11.sp),
                          ),
                        ),
                      )
                          : Container(),
                    ],
                  )
                ],
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
        ),
    ]
      ),
    );
  }
}
