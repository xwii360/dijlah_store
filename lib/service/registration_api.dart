import 'dart:convert';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<bool> signUp(emailOrPhone,name,password) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String url = MAIN_URL + "auth/signup";
  Response response = await post(Uri.parse(url),
   headers: {
    "X-Requested-With" : "XMLHttpRequest",
   },
   body: {
    'email_or_phone':emailOrPhone,
    'name':name,
    'password':password,
     'register_by':"email"
  });
    var data = jsonDecode(response.body);
    var message = data['message'];
     var result = data['result'];
        pref.setString("messages", message);
        pref.setString("result", result.toString());
    if(result==true && message=="Registration Successful. Please verify and log in to your account.") {
      var accessToken = data['access_token'];
      var id = data['user']['id'].toString();
      print(id);
      var email = data['user']['email'];
      var name = data['user']['name'];
      print(name);
      var phone = data['user']['phone'];
      var country = data['user']['country'];
      var userType = data['user']['user_type'];
      pref.setString("access_token", accessToken);
      pref.setString("userId", id);
      pref.setString("email", email);
      pref.setString("name", name);
      pref.setString("phone", phone);
      pref.setString("country", country);
      pref.setString("user_type", userType);
    return true;
  }
    return false;
}
Future<bool> login(String email, String password) async {
  String url = MAIN_URL + "auth/login";
  Map<String, String> body = {'email': email, 'password': password};
  Response response = await post(Uri.parse(url), body: body, headers: {
    "X-Requested-With" : "XMLHttpRequest",
  },);
  print(response.body);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = jsonDecode(response.body);
    print(data);
    var message = data['message'];
  var result = data['result'];
  pref.setString("message", message);
  pref.setString("result", result.toString());
    var user = data['user'];
         if( message=="Successfully logged in" && result==true) {
          pref.setString("user", user.toString());
          var accessToken = data['access_token'];
          var id = data['user']['id'].toString();
          var email = data['user']['email'];
          var name = data['user']['name'];
          var phone = data['user']['phone'];
          var country = data['user']['country'];
          var userType = data['user']['user_type'];
          pref.setString("access_token", accessToken);
          pref.setString("userId", id);
          pref.setString("email", email);
          pref.setString("name", name);
          pref.setString("phone", phone);
          pref.setString("country", country);
          pref.setString("user_type", userType);
          return true;
        }
         else{
           return false;
         }

}
Future<bool> socialLogin(String Email, String Name) async {
  String url = MAIN_URL + "auth/social-login";
  Map<String, String> body = {'email': Email, 'name': Name};
  Response response = await post(Uri.parse(url), body: body, headers: {
    "X-Requested-With" : "XMLHttpRequest",
  },);
  print(response.body);
    var data = jsonDecode(response.body);
  if(response.statusCode==200) {
    if (data['user']['id'] != null) {
      var accessToken = data['access_token'];
      var id = data['user']['id'].toString();
      var email = data['user']['email'];
      var name = data['user']['name'];
      var phone = data['user']['phone'];
      var country = data['user']['country'];
      var userType = data['user']['user_type'];
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("access_token", accessToken);
      pref.setString("userId", id);
      pref.setString("email", email == null ? '' : email);
      pref.setString("name", name == null ? '' : name);
      pref.setString("phone", phone == null ? '' : phone);
      pref.setString("country", country == null ? '' : country);
      pref.setString("user_type", userType);

      return true;
    }
    else{
      return false;
    }

  }
  else{
    return false;
  }
}
Future<String> signUpSeller(fullName,shopName,address,email,password,phone,selectType,selectCountry) async {
  String url = MAIN_URL + "shops/addShopAsNewUser";
  Map<String, String> body = {
    'name': fullName.toString(),
    'shop_name': shopName.toString(),
    'address':address.toString(),
    'email': email.toString(),
    'phone': phone.toString(),
    'state': selectCountry.toString(),
    'password': password.toString(),
    'verification_info': '[{"type":"text","label":"Your name","value":"${fullName.toString()}"},{"type":"text","label":"Shop name","value":"${shopName.toString()}"},{"type":"text","label":"Email","value":"${email.toString()}"},{"type":"text","label":"Phone Number","value":"${phone.toString()}"},{"type":"text","label":"vendor type","value":"${selectType.toString()}"},{"type":"text","label":"state","value":"${selectCountry.toString()}"}]'
  };
  Response response = await post(Uri.parse(url),
      headers: {
        "Accept": "application/json",
      }, body: body);
  print(response.body);
  var data = jsonDecode(response.body);
  print(data);
  return data['message'];
}


Future<bool> loginFaceBook(context,bLoC) async {
   final FacebookLogin facebookSignIn = new FacebookLogin();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final FacebookAccessToken accessToken = result.accessToken;
      var graphResponse = await get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}'));
      var profile = json.decode(graphResponse.body);
      await socialLogin(profile['email'], profile['name']).then((value) {
        if(value==true){
          preferences.setString(
              "login_type", 'facebook');
          preferences.remove("skipLogin");
          showTopFlash(
              context, '', getTranslated(context, "login_successfully"), false);
          Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  HomeScreen(
            bLoC: bLoC,
          )));
        }
        else{
          showTopFlash(context, getTranslated(context, 'login_error'), '', true);
        }
      });
      break;
    case FacebookLoginStatus.cancelledByUser:
      showTopFlash(context, '', getTranslated(context, 'cancelled_login'), true);
      break;
    case FacebookLoginStatus.error:
      print(result.errorMessage);
      showTopFlash(
          context,
          '',
          "${result.errorMessage} ${getTranslated(context, "login_error")} ",
          true);
      break;
  }
   return false;
}

Future<bool> loginWithGoogle(context,bLoC) async {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await googleSignIn.signIn().then((value) async {
    await socialLogin(googleSignIn.currentUser.email,
        googleSignIn.currentUser.displayName).then((value) {
      if(value==true){
        preferences.setString(
            "login_type", 'google');
        preferences.remove("skipLogin");
        showTopFlash(
            context, '', getTranslated(context, "login_successfully"), false);
        Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  HomeScreen(
          bLoC: bLoC,
        )));
      }
      else{
        showTopFlash(context, getTranslated(context, 'login_error'), '', true);
      }
    });
  }).catchError((e) => print(e));
  return false;
}


Future<bool> loginWithPhone(String phoneNumber) async {
  String url = MAIN_URL + "auth/loginPhone";
  Map<String, String> body = {'phone': phoneNumber};
  Response response = await post(Uri.parse(url), body: body, headers: {
    "X-Requested-With" : "XMLHttpRequest",
  },);
  var data = jsonDecode(response.body);
  if(response.statusCode==200) {
    if(data['user']['id'] != null ) {
      var accessToken = data['access_token'];
      var id = data['user']['id'].toString();
      var email = data['user']['email'];
      var name = data['user']['name'];
      var phone = data['user']['phone'];
      var country = data['user']['country'];
      var userType = data['user']['user_type'];
      var phoneVer = data['user']['phone_ver'].toString();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("access_token", accessToken);
      pref.setString("userId", id);
      pref.setString("email", email);
      pref.setString("name", name);
      pref.setString("phone", phone);
      pref.setString("country", country);
      pref.setString("user_type", userType);
      pref.setString("phone_ver", phoneVer);
      return true;
    }
    else{
      return false;
    }
  }
  else{
    return false;
  }
}
Future<bool> loginWithApple(context,bLoC) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if(await AppleSignIn.isAvailable()) {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        print(result.credential.user);//All the required
        print(result.credential.fullName.nickname);
        await socialLogin(result.credential.email ,result.credential.fullName.nickname).then((value) {
          if(value==true){
            preferences.setString(
                "login_type", 'apple');
            preferences.remove("skipLogin");
            showTopFlash(
                context, '', getTranslated(context, "login_successfully"), false);
            Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  HomeScreen(
              bLoC: bLoC,
            )));
          }
          else{
            showTopFlash(context, getTranslated(context, 'login_error'), '', true);
          }
        });
    break;
      case AuthorizationStatus.error:
        showTopFlash(context, getTranslated(context, 'login_error'), '', true);
        print("Sign in failed: ${result.error.localizedDescription}");
        break;
      case AuthorizationStatus.cancelled:
        showTopFlash(context, '', getTranslated(context, 'cancelled_login'), true);
        break;
    }
  }
  else{
    showTopFlash(context, '', getTranslated(context, 'apple_not_available'), true);
    return false;
  }
  return false;
}
