import 'dart:collection';

import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/screens/search.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:dijlah_store_ibtechiq/widget/product_card.dart';
import 'package:dijlah_store_ibtechiq/widget/products_list.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class FlashDealProducts extends StatefulWidget {
  final id;
  final BLoC bLoC;
  final title;
  const FlashDealProducts({Key key, this.id, this.bLoC, this.title}) : super(key: key);

  @override
  _FlashDealProductsState createState() => _FlashDealProductsState();
}

class _FlashDealProductsState extends State<FlashDealProducts> {
  bool isLoading=true;

  @override
  void initState() {
    checkInternet(context).then((value) async {
      if (value == 'ok') {
        widget.bLoC.getFlashDealProductsFuture(widget.id).then((value) =>
            setState(() {
              isLoading = false;
            }));
      }});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: appBarTitle(widget.title??''),
        leading: backArrow(context),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
             Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  Search(
                        bLoC: widget.bLoC,
                      )));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<UnmodifiableListView<Product>>(
    stream: widget.bLoC.allFlashDealProducts,
    initialData:
    UnmodifiableListView<Product>([]),
    builder: (context, snap) {
    if(snap.data.length > 0  && snap.data.isNotEmpty){
    return Column(children:snap.data.map((e) => ProductList(bLoC: widget.bLoC,product: e,)).toList());}
    return  !isLoading?Padding(
      padding: const EdgeInsets.only(top: 158.0),
      child: Center(child: Text(getTranslated(context, 'no_data')),),
    ): SingleChildScrollView(
      child: Column(
          children: List.generate(10,
                  (index) => loadingProductList(context))
              .toList()),
    );
    }),
      ),
      bottomNavigationBar:
      bottomNavigatorBar(context, 0, widget.bLoC, false),
    );
  }
}
