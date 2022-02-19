import 'dart:collection';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'loading.dart';
class ProductMyLike extends StatelessWidget {
  final BLoC bLoC;
  final title;
  const ProductMyLike({Key key, this.bLoC, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizerUtil.deviceType == DeviceType.tablet
                        ? 8.sp
                        : 14.sp,
                    color: Color(0xff404452)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3,
        ),
        StreamBuilder<UnmodifiableListView<Product>>(
            stream: bLoC.allProducts,
            initialData: UnmodifiableListView<Product>([]),
            builder: (context, snap) {
              return snap.hasData && snap.data.isNotEmpty
                  ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: snap.data
                        .map((e) => ProductCard(
                      bLoC: bLoC,
                      product: e,
                    ))
                        .toList(),
                  ),
                ),
              )
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                        10, (e) => loadingProductCard(context)).toList(),
                  ),
                ),
              );
            }),
      ],
    );
  }
}
