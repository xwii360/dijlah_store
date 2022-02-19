import 'dart:collection';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/about_us.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sizer/sizer.dart';
class PolicyAndPrivacy extends StatefulWidget {
  final BLoC bLoC;

  const PolicyAndPrivacy({Key key, this.bLoC}) : super(key: key);
  @override
  _PolicyAndPrivacyState createState() => _PolicyAndPrivacyState();
}
class _PolicyAndPrivacyState extends State<PolicyAndPrivacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
     title: appBarTitle(getTranslated(context, "privacy_and_terms")),
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
              StreamBuilder<UnmodifiableListView<AboutUsAndPrivacy>>(
                  stream: widget.bLoC.aboutUsAndPrivacy,
                  initialData: UnmodifiableListView<AboutUsAndPrivacy>([]),
                  builder: (context, snap) {
                    return snap.hasData && snap.data.isNotEmpty
                        ?  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HtmlWidget(
                          '''<span style="font-family:'sans';font-size:16px;color:black"> ${checkLanguage(context, snap.data[0].privacyAr, snap.data[0].privacyEn, snap.data[0].privacyEn,snap.data[0].privacyAr)}</span>''',
                          webView: true,
                        )):Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(getTranslated(context, "about_us_content"),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ?18:16.0,
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