import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dijlah_store_ibtechiq/languages/localization.dart';
const String LAGUAGE_CODE = 'languageCode';
Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  final String defaultLocale = Platform.localeName;
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? defaultLocale.substring(0,2);
  return _locale(languageCode);
}
Locale _locale(String languageCode) {
  switch (languageCode) {
    case 'en':
      return Locale('en', 'US');
    case 'ar':
      return Locale('ar', "SA");
    // case 'ku':
    //   return Locale('ku', "KU");
    default:
      return Locale('ar', 'SA');
  }
}

String getTranslated(BuildContext context, String key) {
  return Localization.of(context).translate(key);
}