import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/main.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ChooseLanguage extends StatefulWidget {
 final BLoC bLoC;
  const ChooseLanguage({Key key, this.bLoC}) : super(key: key);
  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}
class _ChooseLanguageState extends State<ChooseLanguage> {
  String language;
  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }
  @override
  void initState() {
    getLanguage().then((updateLanguage));
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
          title: appBarTitle(getTranslated(context, "choose_language")),
          leading: backArrow(context),
          centerTitle: false,
        ),
      body: Padding(
        padding: const EdgeInsets.only(top:16.0),
        child: Column(
          children: Language.languageList().map((e) => Column(
            children: [
              ListTile(
                selected: language==e.languageCode?true:false,
                title: Text(e.name=="English"?getTranslated(context,"english_lang"):e.name=="Arabic"?getTranslated(context,"arabic_lang"):e.name=="Kurdish"?getTranslated(context,"kurdish_lang"):""),
                leading: e.name=="English"?Image.asset("assets/en.png",width: 30,height: 30,):e.name=="Arabic"?Image.asset("assets/ar.png",width: 30,height: 30,):e.name=="Kurdish"?Image.asset("assets/ku.png",width: 30,height: 30,):Image.asset("assets/ar.png",width: 30,height: 30,),
                onTap: (){
                  showTopFlash(context,''," ${getTranslated(context,"language_change_successully")} ${e.name=="English"?getTranslated(context,"english_lang"):e.name=="Arabic"?getTranslated(context,"arabic_lang"):getTranslated(context,"kurdish_lang")} ",false);
                  _changeLanguage(e);
                  getLanguage().then((updateLanguage));
                },
              ),
            ],
          )).toList()
        ),
      ),
        bottomNavigationBar: bottomNavigatorBar(context, 4, widget.bLoC, false)
    );
  }
  Future<String> getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString("languageCode");
    if (language == null) {
      return "";
    } else
      return language;
  }
  updateLanguage(String language) {
    setState(() {
      this.language = language;
    });
  }
}
