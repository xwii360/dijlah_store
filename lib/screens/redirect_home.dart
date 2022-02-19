import 'dart:async';
import 'package:dijlah_store_ibtechiq/firebase_service/FireBaseHelper.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/firebase_service/deepLinks.dart';
import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:flutter/material.dart';
class RedirectHome extends StatefulWidget {
  final BLoC bLoC;
  RedirectHome({Key key, this.bLoC});
  @override
  _RedirectHomeState createState() => _RedirectHomeState();
}

class _RedirectHomeState extends State<RedirectHome>{
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(bLoC: widget.bLoC,)));
      FireBaseHelper().init(context,widget.bLoC);
      DeepLinkHelper().init(context,widget.bLoC);
    });

  }
  Widget build(BuildContext context) {
        return Container();
  }
}