import 'dart:io';

import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:dijlah_store_ibtechiq/screens/login.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/screens/about_us.dart';
import 'package:dijlah_store_ibtechiq/screens/all_brands.dart';
import 'package:dijlah_store_ibtechiq/screens/all_shop.dart';
import 'package:dijlah_store_ibtechiq/screens/call_us.dart';
import 'package:dijlah_store_ibtechiq/screens/choose_language.dart';
import 'package:dijlah_store_ibtechiq/screens/help_center.dart';
import 'package:dijlah_store_ibtechiq/screens/orders_history.dart';
import 'package:dijlah_store_ibtechiq/screens/privacy_terms.dart';
import 'package:dijlah_store_ibtechiq/screens/profile.dart';
import 'package:dijlah_store_ibtechiq/screens/refund_history.dart';
import 'package:dijlah_store_ibtechiq/screens/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Settings extends StatefulWidget {
  final BLoC bLoC;
  const Settings({Key key, this.bLoC}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String name = '';
  String phone = '';
  String email = '';
  var _visible = false;
  var _visible2 = false;
  String country = '';
  String loginType='';
  String accessToken='';

  int totalWishList = 0;

  String userType = '';
  void initState() {
    checkInternet(context);
    super.initState();
    checkIfLogin();
    getAccessToken().then((updateAccessToken));
    getPhone().then((updatePhone));
    getLoginType().then((updateLoginType));
    getName().then((updateName));
    getEmail().then((updateEmail));
    getCountry().then((updateCountry));
    getUserType().then((updateUserType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                EdgeInsets.only(top: 10, bottom: 15, right: 20, left: 20),
                color: Colors.blueGrey[50],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      accessToken == ''
                          ? "${getTranslated(context, "please_login")}"
                          : "${getTranslated(context, "welcome")} " + name,
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 11.sp
                              : 18.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      accessToken=='' ? getTranslated(context, "please_login2") : ((email!=''|| email!='empty')&&loginType=='facebook'||loginType=='google')?email:phone,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: SizerUtil.deviceType == DeviceType.tablet
                            ? 7.sp
                            : 13.sp,
                      ),
                      textDirection:  accessToken == "" ?TextDirection.rtl:TextDirection.ltr,
                    ),
                    if(userType=='seller') SizedBox(height: 2,),
                    if(userType=='seller')  Text(getTranslated(context, 'seller'),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red[200]),)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  AllBrands(
                        bLoC: widget.bLoC,
                      )));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: SizerUtil.deviceType == DeviceType.tablet
                              ? 8.w
                              : 14.w,
                          width: SizerUtil.deviceType == DeviceType.tablet
                              ? 8.w
                              : 14.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.teal[300]),
                          child: Center(
                              child: Icon(
                                Icons.branding_watermark_outlined,
                                color: Colors.white,
                                size: SizerUtil.deviceType == DeviceType.tablet
                                    ? 35
                                    : 28,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                              getTranslated(context, "brand"),
                              style: TextStyle(
                                  fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 5.sp
                                      : 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  AllShops(
                        bLoC: widget.bLoC,
                      )));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: SizerUtil.deviceType == DeviceType.tablet
                              ? 8.w
                              : 14.w,
                          width: SizerUtil.deviceType == DeviceType.tablet
                              ? 8.w
                              : 14.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.teal[300]),
                          child: Center(
                              child: Icon(
                                Icons.shopping_bag,
                                color: Colors.white,
                                size: SizerUtil.deviceType == DeviceType.tablet
                                    ? 35
                                    : 28,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                              getTranslated(context, "shops"),
                              style: TextStyle(
                                  fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 5.sp
                                      : 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizerUtil.deviceType == DeviceType.tablet ? 6.w : 9.w,
              ),
              Column(
                children: [
                  if ( accessToken != '' )
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  UpdateProfile(
                          bLoC: widget.bLoC,)));
                      },
                      child: ListTile(
                        leading: Container(
                            height: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            width: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.teal[100],
                            ),
                            child: Icon(
                              FontAwesomeIcons.edit,
                              size: SizerUtil.deviceType == DeviceType.tablet
                                  ?25:18,
                            )),
                        title:
                        Text(getTranslated(context, "edit_profile_info"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                            ?6.5.sp:13.sp,)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size:SizerUtil.deviceType == DeviceType.tablet
                              ?20:16,

                        ),
                      ),
                    ),
                  if(SizerUtil.deviceType == DeviceType.tablet)     if ( accessToken != '')  SizedBox(height: 15,),
                  if ( accessToken != '')
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  OrdersHistory(
                          bLoC: widget.bLoC,
                        )));
                      },
                      child: ListTile(
                        leading: Container(
                            height: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            width: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.teal[100],
                            ),
                            child: Icon(
                              FontAwesomeIcons.history,
                              size:SizerUtil.deviceType == DeviceType.tablet
                                  ?25:18,

                            )),
                        title: Text(getTranslated(context, "order_history"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                            ?6.5.sp:13.sp,)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size:SizerUtil.deviceType == DeviceType.tablet
                              ?20:16,

                        ),
                      ),
                    ),
                  if(SizerUtil.deviceType == DeviceType.tablet)  if ( accessToken != '')  SizedBox(height: 15,),
                  if ( accessToken != '')
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  RefundHistory(
                          bLoC: widget.bLoC,
                        )));
                      },
                      child: ListTile(
                        leading: Container(
                            height: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            width: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.teal[100],
                            ),
                            child: Icon(
                              FontAwesomeIcons.history,
                              size:SizerUtil.deviceType == DeviceType.tablet
                                  ?25:18,

                            )),
                        title: Text(getTranslated(context, 'refund_history'),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                            ?6.5.sp:13.sp,)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size:SizerUtil.deviceType == DeviceType.tablet
                              ?20:16,

                        ),
                      ),
                    ),
                  if(SizerUtil.deviceType == DeviceType.tablet)   if ( accessToken != '')  SizedBox(height: 15,),
                  if ( accessToken != '')
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  WishList(
                          bLoC: widget.bLoC,
                        )));
                      },
                      child: ListTile(
                        leading: Container(
                            width: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            height: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.teal[100],
                            ),
                            child: Icon(
                              FontAwesomeIcons.heart,
                              size:SizerUtil.deviceType == DeviceType.tablet
                                  ?25:18,

                            )),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(getTranslated(context, "wish_list"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                                ?6.5.sp:13.sp,),),
                            ValueListenableBuilder(
                                valueListenable: wishListQuantity,
                                builder: (context, value, child) {
                                  return value == 0
                                      ? Container()
                                      : Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        color: Colors.teal[400],
                                      ),
                                      width: SizerUtil.deviceType == DeviceType.tablet
                                          ? 3.w
                                          : 5.w,
                                      height: SizerUtil.deviceType == DeviceType.tablet
                                          ? 3.w
                                          : 5.w,
                                      child: Center(
                                          child: Text(
                                            value.toString(),
                                            style: TextStyle(
                                                fontSize: SizerUtil.deviceType == DeviceType.tablet
                                                    ?6.sp:10.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )));
                                })
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size:SizerUtil.deviceType == DeviceType.tablet
                              ?20:16,

                        ),
                      ),
                    ),
                  if(SizerUtil.deviceType == DeviceType.tablet)   SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  ChooseLanguage(
                        bLoC: widget.bLoC,
                      )));
                    },
                    child: ListTile(
                      leading: Container(
                          width: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          height: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.teal[100],
                          ),
                          child: Icon(
                            FontAwesomeIcons.language,
                            size: SizerUtil.deviceType == DeviceType.tablet
                                ? 18
                                : 23,
                          )),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated(context, "choose_language"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                              ?6.5.sp:13.sp,)),
                          Text(getTranslated(context, "language_title"),style: TextStyle(fontFamily: 'sans',fontSize:SizerUtil.deviceType == DeviceType.tablet
                              ?18: 14,color: Colors.teal[700]),),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size:SizerUtil.deviceType == DeviceType.tablet
                            ?20:16,

                      ),
                    ),
                  ),
                if(SizerUtil.deviceType == DeviceType.tablet)  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      Share.share(
                          '${getTranslated(context, "share_app_with")}  http://onelink.to/dijlah');
                    },
                    child: ListTile(
                      leading: Container(
                          width: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          height: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.teal[100],
                          ),
                          child: Icon(
                            FontAwesomeIcons.shareAlt,
                            size:SizerUtil.deviceType == DeviceType.tablet
                                ?25:18,

                          )),
                      title: Text(getTranslated(context, "share_app"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                          ?6.5.sp:13.sp,)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size:SizerUtil.deviceType == DeviceType.tablet
                            ?20:16,

                      ),
                    ),
                  ),
                  if(SizerUtil.deviceType == DeviceType.tablet)  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  CallUs(
                        bLoC: widget.bLoC,
                      )));
                    },
                    child: ListTile(
                      leading: Container(
                          width: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          height: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.teal[100],
                          ),
                          child: Icon(
                            FontAwesomeIcons.stickyNote,
                            size:SizerUtil.deviceType == DeviceType.tablet
                                ?25:18,

                          )),
                      title: Text(getTranslated(context, "call_us"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                          ?6.5.sp:13.sp,)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size:SizerUtil.deviceType == DeviceType.tablet
                            ?20:16,

                      ),
                    ),
                  ),
                  if(SizerUtil.deviceType == DeviceType.tablet)   SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  HelperCenter(
                        bLoC: widget.bLoC,
                      )));
                    },
                    child: ListTile(
                      leading: Container(
                          width: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          height: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.teal[100],
                          ),
                          child: Icon(
                            FontAwesomeIcons.phoneAlt,
                            size:SizerUtil.deviceType == DeviceType.tablet
                                ?25:18,

                          )),
                      title: Text(getTranslated(context, "helper_center"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                          ?6.5.sp:13.sp,)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size:SizerUtil.deviceType == DeviceType.tablet
                            ?20:16,

                      ),
                    ),
                  ),
                  if(SizerUtil.deviceType == DeviceType.tablet)   SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutUs(bLoC: widget.bLoC,)));
                    },
                    child: ListTile(
                      leading: Container(
                          width: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          height: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.teal[100],
                          ),
                          child: Icon(
                            FontAwesomeIcons.info,
                            size:SizerUtil.deviceType == DeviceType.tablet
                                ?25:18,

                          )),
                      title: Text(getTranslated(context, "about_us"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                          ?6.5.sp:13.sp,)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size:SizerUtil.deviceType == DeviceType.tablet
                            ?20:16,

                      ),
                    ),
                  ),
                  if(SizerUtil.deviceType == DeviceType.tablet)   SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PolicyAndPrivacy(bLoC: widget.bLoC,)));
                    },
                    child: ListTile(
                      leading: Container(
                          width: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          height: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.w
                              : 9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.teal[100],
                          ),
                          child: Icon(
                            Icons.local_police,
                            size:SizerUtil.deviceType == DeviceType.tablet
                                ?25:18,

                          )),
                      title: Text(getTranslated(context, "privacy_and_terms"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                          ?6.5.sp:13.sp,)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size:SizerUtil.deviceType == DeviceType.tablet
                            ?20:16,

                      ),
                    ),
                  ),
                  if(SizerUtil.deviceType == DeviceType.tablet)   SizedBox(height: 15,),
                  Visibility(
                    visible: _visible,
                    child: GestureDetector(
                      onTap: () => logOut(context),
                      child: ListTile(
                        leading: Container(
                            width: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            height: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.teal[100],
                            ),
                            child: Icon(
                              FontAwesomeIcons.signOutAlt,
                              size:SizerUtil.deviceType == DeviceType.tablet
                                  ?25:18,

                            )),
                        title: Text(getTranslated(context, "logout"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                            ?6.5.sp:13.sp,)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size:SizerUtil.deviceType == DeviceType.tablet
                              ?20:16,

                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _visible2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login(
                                  bLoC: widget.bLoC,
                                )),
                                (route) => false);
                      },
                      child: ListTile(
                        leading: Container(
                            width: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            height: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.w
                                : 9.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.teal[100],
                            ),
                            child: Icon(
                              FontAwesomeIcons.signInAlt,
                              size:SizerUtil.deviceType == DeviceType.tablet
                                  ?25:18,

                            )),
                        title: Text(getTranslated(context, "login"),style: TextStyle( fontSize:SizerUtil.deviceType == DeviceType.tablet
                            ?6.5.sp:13.sp,)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size:SizerUtil.deviceType == DeviceType.tablet
                              ?20:16,

                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar:  bottomNavigatorBar(context, 4, widget.bLoC, false),
    );
  }

  Future<String> getName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String name = sharedPreferences.getString("name");
    if (name == null) {
      return "";
    } else
      return name;
  }

  Future<String> getEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String email = sharedPreferences.getString("email");
    if (email == null) {
      return "";
    } else
      return email;
  }

  Future<String> getPhone() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String phone = sharedPreferences.getString("phone");
    if (phone == null) {
      return "";
    } else
      return phone;
  }

  Future<String> getUserType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userType = sharedPreferences.getString("user_type");
    if (userType == null) {
      return "";
    } else
      return userType;
  }

  Future<String> getCountry() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String country = sharedPreferences.getString("country");
    if (country == null) {
      return "";
    } else
      return country;
  }
  Future<String> getLoginType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String login = sharedPreferences.getString("login_type");
    if (login == null) {
      return "";
    } else
      return login;
  }
  Future<String> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String access = sharedPreferences.getString("access_token");
    if (access == null) {
      return "";
    } else
      return access;
  }

  updatePhone(String phone) {
    setState(() {
      this.phone = phone;
    });
  }

  updateUserType(String userType) {
    setState(() {
      this.userType = userType;
    });
  }

  updateCountry(String country) {
    setState(() {
      this.country = country;
    });
  }

  updateEmail(String email) {
    setState(() {
      this.email = email;
    });
  }

  updateName(String name) {
    setState(() {
      this.name = name;
    });
  }
  updateLoginType(String login) {
    setState(() {
      this.loginType = login;
    });
  }
  updateAccessToken(String accessToken) {
    setState(() {
      this.accessToken = accessToken;
    });
  }
  Future getLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user_token = preferences.getString("access_token");
    Response response = await get(Uri.parse(MAIN_URL+"auth/logout"),
      headers: {
        "Authorization": "Bearer $user_token"
      },
    );
    print(response.body);
  }
  Future logOut(BuildContext context) async {
    await facebookSignIn.logOut();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    getLogout();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    for(String key in preferences.getKeys()) {
      if(key != "languageCode" && key != "seeBoarding") {
        preferences.remove(key);
      }
    }
    wishListQuantity.value = 0;
    cartQuantity.value = 0;
    showTopFlash(
        context, '', getTranslated(context, "logout_successfully"), false);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen(
                  bLoC: widget.bLoC,
                )));
  }

  checkIfLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String accessToken = preferences.getString('access_token');
    String skip = preferences.getString('skipLogin');

    if ((skip == "1" && accessToken == null) ||  accessToken == null){
      setState(() {
        _visible = false;
        _visible2 = true;
      });
    }
    else {
      setState(() {
        _visible = true;
        _visible2 = false;
      });
    }
  }
}
