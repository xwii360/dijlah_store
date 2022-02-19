import 'dart:collection';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/about_us.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
class AboutUs extends StatefulWidget {
  final BLoC bLoC;

  const AboutUs({Key key, this.bLoC}) : super(key: key);
  @override
  _AboutUsState createState() => _AboutUsState();
}
class _AboutUsState extends State<AboutUs> {

  @override
  void initState() {
    checkInternet(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
    title: appBarTitle(getTranslated(context, "about_us")),
    titleSpacing: 0.0,
    leading: backArrow(context),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(getTranslated(context, "app_name"),style: TextStyle(fontSize: 25,fontFamily: 'sans',fontWeight: FontWeight.bold,color: Colors.blueGrey),),
              ),
    StreamBuilder<UnmodifiableListView<AboutUsAndPrivacy>>(
    stream: widget.bLoC.aboutUsAndPrivacy,
    initialData: UnmodifiableListView<AboutUsAndPrivacy>([]),
    builder: (context, snap) {
     return snap.hasData && snap.data.isNotEmpty
          ?  Padding(
       padding: const EdgeInsets.all(8.0),
       child: HtmlWidget(
         '''<span style="font-family:'sans';font-size:16px;color:black"> ${checkLanguage(context, snap.data[0].aboutUsAr, snap.data[0].aboutUsEn, snap.data[0].aboutUsKu,snap.data[0].aboutUsAr)}</span>''',
         webView: true,
       )):Padding(
         padding: const EdgeInsets.all(16.0),
      child: Text(getTranslated(context, "about_us_content"),
      style: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: "sans",
      ),
      textAlign: TextAlign.justify,
      ));
    })
            ],
          ),
        ),
      ),
    );
  }
}