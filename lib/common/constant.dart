import 'dart:collection';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/custom_page.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/screens/cart.dart';
import 'package:dijlah_store_ibtechiq/screens/categories.dart';
import 'package:dijlah_store_ibtechiq/screens/detail_product.dart';
import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:dijlah_store_ibtechiq/screens/settings.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../service/bLoC.dart';

/////////// main url api //////////////////////////////////////////
const String MAIN_URL = "https://dijlah-store.com/api/v1/";
const String MAIN_URL2 = "https://dijlah-store.com/AppAPI/Api/";
const String IMAGE_URL = "https://dijlah-store.com/public/";
///////  number of news  per page /////////////////
const String perPage = "10";
const String firstPerPage = "20";
List<String> statesAr = [
  'الأنبار',
  'بابل',
  'بغداد',
  'البصرة',
  'ذي قار',
  'ديالى',
  'دهوك',
  'أربيل',
  'كربلاء',
  'كركوك',
  'ميسان',
  'المثنى',
  'النجف',
  'نينوى',
  'القادسية',
  'صلاح الدين',
  'السليمانية',
  'واسط',
  'حلبجة'
];
//List<String> statesEn=['Al Anbar','Babil','Baghdad','Basra','Dhi Qar','Al-Qādisiyyah','Diyala','Duhok','Erbil','Halabja','Karbala','Kirkuk','Maysan','Muthanna','Najaf','Nineveh','Saladin','Sulaymaniyah','Wasit'];
//////////////////////////////////////////
bottomNavigatorBar(context, index, bLoC, isHome) {
  return StreamBuilder<UnmodifiableListView<CustomPage>>(
      stream: bLoC.customPage,
      initialData: UnmodifiableListView<CustomPage>([]),
      builder: (context, snap) {
        return BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          onTap: (indexes) {
            if (indexes == 0) {
              if (isHome == true) {
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: HomeScreen(
                          bLoC: bLoC,
                        )),
                    (route) => false);
              }
            } else if (indexes == 1) {
              if (indexes == index) {
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: Categories(
                          bLoC: bLoC,
                        )));
              }
            } else if (snap.data.isNotEmpty && indexes == 2) {
              if (indexes == index) {
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: Products(
                          bLoC: bLoC,
                          id: snap.data[0].categoryId,
                          title: checkLanguageImage(
                              context,
                              snap.data[0].title[0],
                              snap.data[0].title[1],
                              snap.data[0].title[2]),
                          pageId: snap.data[0].id,
                          getFrom: "custom",
                        )));
              }
            } else if (snap.data.isNotEmpty && indexes == 3) {
              if (indexes == index) {
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: Cart(
                          bLoC: bLoC,
                        )));
              }
            } else if (snap.data.isEmpty && indexes == 2) {
              if (indexes == index - 1) {
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: Cart(
                          bLoC: bLoC,
                        )));
              }
            } else if (snap.data.isNotEmpty && indexes == 4) {
              if (indexes == index) {
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: Settings(
                          bLoC: bLoC,
                        )));
              }
            } else if (snap.data.isEmpty && indexes == 3) {
              if (indexes == index - 1) {
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: Settings(
                          bLoC: bLoC,
                        )));
              }
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                index == 0 ? Icons.home : Icons.home_outlined,
                color: index == 0 ? color1 : Colors.grey[500],
                size: SizerUtil.deviceType == DeviceType.tablet
                    ?35:18,
              ),
              title: new Text(getTranslated(context, 'home_page'),
                  style: TextStyle(
                      color: index == 0 ? color1 : Colors.grey[700],
                      fontFamily: "sans",
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ?16:13)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                index == 1 ? Icons.content_copy : Icons.content_copy_outlined,
                color: index == 1 ? color1 : Colors.grey[500],
                size: SizerUtil.deviceType == DeviceType.tablet
                    ?35:18,
              ),
              title: new Text(getTranslated(context, 'category'),
                  style: TextStyle(
                      color: index == 1 ? color1 : Colors.grey[700],
                      fontFamily: "sans",
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ?16:13)),
            ),
            if (snap.data.isNotEmpty)
              BottomNavigationBarItem(
                icon: CachedNetworkImage(
                    imageUrl: IMAGE_URL + snap.data[0].icon,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.contain,
                    height: SizerUtil.deviceType == DeviceType.tablet
                        ?28:24,
                    width: SizerUtil.deviceType == DeviceType.tablet
                        ?28:24
                ),
                title: new Text(
                    snap.data.isNotEmpty
                        ? checkLanguageImage(context, snap.data[0].title[0],
                            snap.data[0].title[1], snap.data[0].title[2])
                        : '',
                    style: TextStyle(
                        color: index == 2 ? color1 : Colors.grey[700],
                        fontFamily: "sans",
                        fontSize: SizerUtil.deviceType == DeviceType.tablet
                            ?16:13)),
              ),
            BottomNavigationBarItem(
              icon: ValueListenableBuilder(
                  valueListenable: cartQuantity,
                  builder: (context, value, child) {
                    return Badge(
                      elevation: 0,
                      position: BadgePosition.topStart(),
                      badgeColor:
                          value == 0 ? Colors.transparent : Colors.teal[300],
                      badgeContent: Text(value == 0 ? '' : value.toString(),
                          style: TextStyle(fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ?13:10, fontFamily: "sans")),
                      child: Icon(
                        index == 3
                            ? Icons.shopping_cart
                            : Icons.shopping_cart_outlined,
                        color: index == 3 ? color1 : Colors.grey[500],
                        size: SizerUtil.deviceType == DeviceType.tablet
                            ?35:18,
                      ),
                    );
                  }),
              title: new Text(getTranslated(context, 'cart'),
                  style: TextStyle(
                      color: index == 3 ? color1 : Colors.grey[700],
                      fontFamily: "sans",
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ?16:13)),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  index == 4
                      ? Icons.person_rounded
                      : Icons.person_outline_rounded,
                  color: index == 4 ? color1 : Colors.grey[500],
                  size: SizerUtil.deviceType == DeviceType.tablet
                      ?35:18,
                ),
                title: Text(
                  getTranslated(context, 'profile'),
                  style: TextStyle(
                      color: index == 4 ? color1 : Colors.grey[700],
                      fontFamily: "sans",
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ?16:13),
                ))
          ],
        );
      });
}
/////////////////////////////////////////
Future<Product> getProduct(id) async {
  String url = MAIN_URL + "products/$id";
  Response response = await get(Uri.parse(url));
  var data = json.decode(response.body);
  var infoData = data["data"];
  print(infoData);
  return Product.fromJson(infoData[0]);
}
//////////////////////////////////////////////////////////////////////////
Future<void> createDynamicLink(String id) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://dijlahstore.page.link',
    link: Uri.parse('https://dijlah-store.com/$id'),
    androidParameters: AndroidParameters(
      packageName: 'com.dijlahstore.ibtechiq',
      minimumVersion: 0,
    ),
    dynamicLinkParametersOptions: DynamicLinkParametersOptions(
      shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
    ),
    iosParameters: IosParameters(
      bundleId: 'com.dijlahstore.ibtechiq',
      minimumVersion: '0',
    ),
  );
  Uri url;
  final ShortDynamicLink shortLink = await parameters.buildShortLink();
  url = shortLink.shortUrl;
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("url", url.toString());
}
/////////////////////////////////////
Future<bool> alert(context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              getTranslated(context, "exist_app"),
              style: TextStyle(
                fontSize: 17,
                fontFamily: "sans",
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  getTranslated(context, "no"),
                  style: TextStyle(
                    fontFamily: "sans",
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  getTranslated(context, "yes"),
                  style: TextStyle(
                    fontFamily: "sans",
                  ),
                ),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            ],
          ));
}

loadingGetMore(context, height) {
  return Container(
      alignment: Alignment.center,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Loading(
              indicator: BallBeatIndicator(),
              size: 30.0,
              color: Theme.of(context).accentColor),
          SizedBox(width: 10,),
          Text(getTranslated(context, 'loading'),style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      ));
}
checkLanguage(context, ar, en, ku, name) {
  if (getTranslated(context, "language") == "sa") {
    if (ar == '' || ar == null) {
      return name;
    } else {
      return ar;
    }
  } else if (getTranslated(context, "language") == "en") {
    if (en == '' || en == null) {
      return name;
    } else {
      return en;
    }
  } else if (getTranslated(context, "language") == "ku") {
    if (ku == '' || ku == null) {
      return name;
    } else {
      return ku;
    }
  } else {
    return name;
  }
}
checkLanguageImage(context, image1, image2, image3) {
  if (getTranslated(context, "language") == "sa") {
    if (image1 == '' || image1 == null) {
      return image1;
    } else {
      return image1;
    }
  } else if (getTranslated(context, "language") == "en") {
    if (image2 == '' || image2 == null) {
      return image1;
    } else {
      return image2;
    }
  } else if (getTranslated(context, "language") == "ku") {
    if (image3 == '' || image3 == null) {
      return image1;
    } else {
      return image3;
    }
  } else {
    return image1;
  }
}
bannersRedirect(context, bLoC, banner) {
  if (banner.type == '0') {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: Products(
              bLoC: bLoC,
              id: banner.typeId,
              title: banner.typeName == null ? '' : banner.typeName,
              getFrom: "category",
            )));
  } else if (banner.type == '1') {
    if (banner.product != null)
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: DetailProduct(
                bLoC: bLoC,
                product: banner.product,
              )));
  } else if (banner.type == '2') {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: Products(
              bLoC: bLoC,
              id: banner.typeId,
              title: banner.typeName == null ? '' : banner.typeName,
              getFrom: "brand",
            )));
  } else if (banner.type == '3') {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: Products(
              bLoC: bLoC,
              id: banner.typeId,
              title: banner.typeName == null ? '' : banner.typeName,
              getFrom: "shop",
            )));
  } else {}
}
showTopFlash(context, text1, text2, isError) {
  showFlash(
    context: context,
    duration: const Duration(seconds: 3),
    persistent: true,
    builder: (_, controller) {
      return Flash(
        controller: controller,
        backgroundColor: isError ? Colors.red[300] : Colors.teal[300],
        brightness: Brightness.light,
        barrierBlur: 0.0,
        barrierDismissible: true,
        behavior: FlashBehavior.floating,
        position: FlashPosition.top,
        child: FlashBar(
          title: Text(
            text2,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'sans',
                color: Colors.white,
                fontSize: 16),
          ),
          content: Text(
            text1,
            style: TextStyle(
                fontFamily: 'sans', color: Colors.white, fontSize: 14),
          ),
          icon: Icon(
            isError ? Icons.error_outline : Icons.done,
            size: 40,
            color: Colors.white,
          ),
          showProgressIndicator: false,
        ),
      );
    },
  );
}
Future<String> checkInternet(context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.mobile &&
      connectivityResult != ConnectivityResult.wifi) {
    return showTopFlash(
        context,
        getTranslated(context, 'no_internet_description'),
        getTranslated(context, 'no_internet'),
        true);
  }
  return 'ok';
}
backArrow(context) {
  return Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: SizerUtil.deviceType == DeviceType.tablet ? 25 : 19,
      ),
    ),
  );
}
appBarTitle(title) {
  return Text(
    title,
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: SizerUtil.deviceType == DeviceType.tablet ? 7.sp : 16.sp,
    ),
  );
}
isBlankData(data) {
  if (data == null || data == '' || data.toString().isEmpty) {
    if (data.runtimeType == String || data.runtimeType == Null) {
      return '';
    }
    if (data.runtimeType == int) {
      return 0;
    }
    if (data.runtimeType == double) {
      return 0.0;
    }
    return '';
  } else {
    return data;
  }
}
