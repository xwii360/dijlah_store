import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/home_sections.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:dijlah_store_ibtechiq/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class ProductsHomeView extends StatelessWidget {
  final HomeSections e;
  final BLoC bLoC;
  const ProductsHomeView({Key key, this.e, this.bLoC}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0, bottom: 15,left: 12,top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                checkLanguageImage(context, e.title[0], e.title[1],e.title[2]),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizerUtil.deviceType == DeviceType.tablet?8.sp:14.sp,
                    color: Color(0xff404452)),
              ),
              GestureDetector(
                onTap: (){
                 Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
                              Products(
                                bLoC: bLoC,
                                id: e.categoryId,
                                title: getTranslated(context, "all_products_title"),
                                getFrom: "category",
                              )));
                },
                child: Text(
                  getTranslated(context, "see_all"),
                  style: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:11.sp,fontWeight: FontWeight.bold,
                      color: Color(0xff404452)),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8,bottom: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:e.products
                  .map<Widget>((e) => ProductCard(
                bLoC: bLoC,
                product: e,
              ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
