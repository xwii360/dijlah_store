import 'dart:async';
import 'dart:collection';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/shop.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:dijlah_store_ibtechiq/widget/shop_card.dart';
import 'package:flutter/material.dart';
class AllShops extends StatefulWidget {
  final BLoC bLoC;
  const AllShops({Key key, this.bLoC}) : super(key: key);
  @override
  _AllShopsState createState() => _AllShopsState();
}

class _AllShopsState extends State<AllShops> {
  Timer timer;
  bool _visibleList = true;
  bool _visibleText=false;

  @override
  void initState() {
    super.initState();
    checkInternet(context);
    Future.delayed(const Duration(seconds: 5), () {
      if (this.mounted) {
        setState(() {
          _visibleList = false;
          _visibleText = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: appBarTitle(getTranslated(context, "shops")),
        titleSpacing: 0.0,
        leading: backArrow(context),
        centerTitle: false,
      ),
      body: StreamBuilder<UnmodifiableListView<AllShop>>(
          stream: widget.bLoC.allShops,
          initialData: UnmodifiableListView<AllShop>([]),
          builder: (context, snap) {
            return snap.hasData&&snap.data.isNotEmpty?SingleChildScrollView(
                child: Column(
                  children: snap.data
                      .map((e) => ShopCard(bLoC: widget.bLoC,shop: e,))
                      .toList(),
                )):SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible:_visibleText,
                        child: Padding(
                          padding: const EdgeInsets.only(top:158.0),
                          child: Center(child: Text(getTranslated(context, 'no_data')),),
                        ),
                      ),
                      Visibility(
              visible:_visibleList,
                        child: Column(
                                children: List.generate(10, (index) => loadingShopList(context)),
                        ),
                      ),
                    ],
                  ),
                );
          }),
      bottomNavigationBar: bottomNavigatorBar(context, 0, widget.bLoC, true),
    );
  }
}
