import 'dart:async';
import 'dart:collection';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/all_brands.dart';
import 'package:dijlah_store_ibtechiq/widget/brand_card.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class AllBrands extends StatefulWidget {
  final BLoC bLoC;
  const AllBrands({Key key, this.bLoC}) : super(key: key);
  @override
  _AllBrandsState createState() => _AllBrandsState();
}
class _AllBrandsState extends State<AllBrands> {
  Timer timer;
  bool _visibleList = true;

  bool _visibleText=false;

  @override
  void initState() {
    checkInternet(context);
    super.initState();
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
        title: appBarTitle(getTranslated(context, "brand")),
        titleSpacing: 0.0,
        leading: backArrow(context),
        centerTitle: false,
      ),
      body: StreamBuilder<UnmodifiableListView<AllBrand>>(
          stream: widget.bLoC.allBrands,
          initialData: UnmodifiableListView<AllBrand>([]),
          builder: (context, snap) {
            return snap.data.isNotEmpty&&snap.hasData?SingleChildScrollView(
                child:
                GridView.count(
                  shrinkWrap: true,
                  physics:
                  NeverScrollableScrollPhysics(),
                  crossAxisCount: SizerUtil.deviceType == DeviceType.tablet?5:3,
                  childAspectRatio: 0.83,
                  padding:
                  const EdgeInsets.all(4.0),
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  children: snap.data
                      .map(
                        (i) => BrandsCard(bLoC: widget.bLoC,brand: i,),
                  )
                      .toList(),
                )):SingleChildScrollView(
                  child: Column(
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
                        child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              children: List.generate(18,
                            (i) => loadingBrand(context),
              )
                          .toList(),
            ),
                      ),
                    ],
                  ),
                );
          }),
      bottomNavigationBar: bottomNavigatorBar(context, 4, widget.bLoC, false),
    );
  }
}
