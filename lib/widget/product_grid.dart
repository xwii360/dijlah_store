import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/screens/detail_product.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class ProductGrid extends StatefulWidget {
  final BLoC bLoC;
  final Product product;

  const ProductGrid({Key key, this.bLoC, this.product}) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  var attributes='';
  String color='';
  @override
  Widget build(BuildContext context) {
    return   Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      crossAxisAlignment:
      CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailProduct(bLoC: widget.bLoC,product: widget.product,)));
          },
          child: Stack(
            children: [
              Container(
                height: SizerUtil.deviceType == DeviceType.tablet? 485:355,
                width:SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[200],width: 1),
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: <Widget>[
                        Container(
                          height:SizerUtil.deviceType == DeviceType.tablet?330:240,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  CachedNetworkImage(
                              imageUrl: IMAGE_URL + widget.product.thumbnailImage,
                             placeholder: (context, url) =>
                                                                    loadingSliderHomePage(
                                                                        context,
                                                                        SizerUtil.deviceType == DeviceType.tablet?330.0:220.0,
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .width),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.fill,
                              height: SizerUtil.deviceType == DeviceType.tablet?330:220,
                              width: SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                            )
                          ),
                        ),
                  Padding(
                    padding:
                    EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        top: 0),
                    child: Container(
                      width: SizerUtil.deviceType == DeviceType.tablet? 100.w:100.w,
                      height: SizerUtil.deviceType == DeviceType.tablet?70:45,
                      child: Text(
                          checkLanguage(context,widget.product.arabicName,widget.product.enName,widget.product.kuName,widget.product.name),
                        style: TextStyle(
                            fontFamily:
                            "sans",
                            color: Colors
                                .grey[900],
                            fontSize:  SizerUtil.deviceType == DeviceType.tablet?7.sp:12.sp),
                        overflow:
                        TextOverflow
                            .ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,right: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.product.discount != 0.00 ? double.parse(widget.product.baseDiscountedPrice.toString()).toInt() : widget.product.basePrice} ${getTranslated(context, "short_currency")} ",
                          style: TextStyle(fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:11.sp,color: Colors.grey[900],fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        widget.product.discount != 0.00
                            ? Text(
                          "${widget.product.basePrice.toString()} ${getTranslated(context, "short_currency")} ",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[400],
                              fontSize: SizerUtil.deviceType == DeviceType.tablet?5.sp:11.sp),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
              Positioned(
                  top: 1,
                  left: 1,

                  child: widget.product.discount != 0.00
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.green[50],
                      padding: EdgeInsets.only(left: 8,right: 8),
                      child: Text(
                        " ${getTranslated(context, 'sale_off')} ${widget.product.discount}%",
                        style: TextStyle(
                            color: Colors.green[600],
                            fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:10.sp),
                      ),
                    ),
                  )
                      : Container(),)
                ]
          ),
        )
      ],
    );
  }
}
