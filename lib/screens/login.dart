import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dijlah_store_ibtechiq/screens/login_as_seller.dart';
import 'package:dijlah_store_ibtechiq/service/registration_api.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final BLoC bLoC;
  const Login({Key key, this.bLoC}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNo, verificationId;
  bool codeSent = false;
  bool phonePage = true;
  var countryCode='+964';
  final _formKey = new GlobalKey<FormState>();
  bool loading = false;
  var statusVer;
  @override
  void initState() {
    checkInternet(context);
    // if(Platform.isIOS){
    //   AppleSignIn.onCredentialRevoked.listen((_) {
    //     print("Credentials revoked");
    //   });
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated(context, "welcome"),
                          style: loginTitleStyle1,
                        ),
                        SizedBox(height: 5),
                        Text(
                          getTranslated(context, "continue_login"),
                          style: loginTitleStyle2,
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginAsSeller(
                                        bLoC: widget.bLoC,
                                      )),
                              (route) => false);
                        },
                        child: Text(
                          getTranslated(context, "login_as_seller"),
                          style: loginTitleStyle3,
                        ))
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    phonePage
                        ? Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                               getTranslated(context, 'phone_number'),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormField(
                              controller: phoneController,
                              autofocus: false,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(context, 'phone_number_required_filed');
                                }
                                return null;
                              },

                              autocorrect: false,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: Colors.grey[800], width: 1.2),
                                ),
                                alignLabelWithHint: false,
                                suffixIcon: Icon(
                                  Icons.phone_android,
                                  color: Colors.teal,
                                ),
                                labelText: getTranslated(context, "phone_number"),
                                prefixIcon:SizedBox(
                                  width: 80,
                                  child: Center(
                                    child: CountryCodePicker(
                                      onChanged: (code){
                                        setState(() {
                                          print(code.dialCode);
                                          countryCode=code.dialCode;
                                        });
                                      },
                                      initialSelection: 'IQ',
                                      countryFilter: ['IQ','TR','US','CA','JO'],
                                      showCountryOnly: false,
                                      showOnlyCountryWhenClosed: false,
                                      alignLeft: true,
                                      showFlagMain: false,
                                    ),
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  this.phoneNo = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    codeSent
                        ? WillPopScope(
                      onWillPop: () async {
                        smsCodeController.clear();
                        setState(() {
                          this.phonePage = true;
                          this.codeSent = false;
                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  getTranslated(context, 'pin_code'),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextFormField(
                                controller: smsCodeController,
                                autofocus: false,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return getTranslated(context, 'pin_code_required');
                                  }
                                  return null;
                                },
                                autocorrect: false,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(
                                          color: Colors.teal[300],
                                          width: 1),
                                    ),
                                    alignLabelWithHint: false,
                                    suffixIcon: Icon(
                                      Icons.check_circle,
                                      color: Colors.teal,
                                    ),
                                    labelText: getTranslated(context, 'pin_code'),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Container(),

                SizedBox(height: 30,),
                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Color(0xff86f7b6), Color(0xff8fd3f1)],
                          ),
                        ),
                        child: RaisedButton(
                            color: Colors.transparent,
                              elevation: 0,

                              child: Center(
                                  child: loading?SizedBox(width:20,height:20,child: CircularProgressIndicator()):codeSent
                                      ? Text(
                                    getTranslated(context, 'check'),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                                      : Text(
                                    getTranslated(context, 'send'),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                                  pref.setString(
                                      "login_type", 'phone');
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  if (codeSent) {
                                    if (smsCodeController.text.trim().length <
                                        6) {
                                      showTopFlash(context,"",getTranslated(context, 'pin_code_less_than'),false);
                                    } else if (smsCodeController.text
                                        .trim()
                                        .length >
                                        6) {
                                      showTopFlash(context,"",getTranslated(context, 'pin_code_more_than'),false);
                                    } else if (smsCodeController.text
                                        .trim()
                                        .length ==
                                        6) {
                                      setState(() {
                                        loading = true;
                                      });
                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithCredential(
                                            PhoneAuthProvider.credential(
                                                verificationId: verificationId,
                                                smsCode: smsCodeController
                                                    .text)).then((value) async {
                                          if (value.user.phoneNumber != null) {
                                            await loginWithPhone(getPhoneNumber(phoneNo)).then((value) {
                                              if(value==true){
                                                setState(() {
                                                  loading = false;
                                                });
                                                showTopFlash(context, getTranslated(context, 'login_successfully'), '', false);
                                                Navigator.pushAndRemoveUntil(
                                                    context, MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen(
                                                          bLoC: widget.bLoC,)), (
                                                    route) => false);
                                              }
                                              else{
                                                setState(() {
                                                  loading = false;
                                                });
                                                showTopFlash(context, getTranslated(context, 'login_error'), '', true);
                                              }
                                            });

                                          }
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                      }
                                      catch(e){
                                        FocusScope.of(context).unfocus();
                                        showTopFlash(context, '', 'invalid otp', true);
                                      }
                                    }

                                  } else {
                                    if(countryCode=='+964') {
                                      if (phoneNo.length < 10) {
                                        showTopFlash(context, "", getTranslated(
                                            context, 'phone_more_than'), true);
                                      } else if (phoneNo.startsWith("0")) {
                                        showTopFlash(context, "", getTranslated(
                                            context, 'remove_zero'), true);
                                      } else if (phoneNo.length > 10) {
                                        showTopFlash(context, "", getTranslated(
                                            context, 'phone_less_than'), true);
                                      } else if (phoneNo.length == 10) {
                                        confirmPhoneFromAppDialog();
                                      }
                                    }
                                    else{
                                      confirmPhoneFromAppDialog();
                                    }
                                  }
                                }
                              }),
                      ))),
                    codeSent?  Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top:18.0),
                        child: TextButton(onPressed: (){
                          setState(() {
                            phonePage=true;
                            codeSent=false;
                          });
                        }, child: Text(getTranslated(context, 'resend_pin'),style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold),)),
                      ),
                    ):Container(),
                    if(Platform.isAndroid)  SizedBox(
                      height: 30,
                    ),
                    if(Platform.isAndroid)   Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 48,
                        child: RaisedButton.icon(
                          color: Colors.white,
                          elevation: 0,
                          shape: shape1,
                          onPressed: () {
                            checkInternet(context).then((value) async {
                              if (value == 'ok') {
                                setState(() {
                                  loading=true;
                                });
                                await loginFaceBook(context, widget.bLoC).then((value){
                                  setState(() {
                                    loading=false;
                                  });
                                });
                              }
                            });
                          },
                          icon: Icon(FontAwesomeIcons.facebookF),
                          label: Text(
                            getTranslated(context, "facebook_login"),
                            style: button2TextLogin,
                          ),
                        ),
                      ),
                    ),

                    if(Platform.isAndroid) SizedBox(
                      height: 10,
                    ),
                    if(Platform.isAndroid)    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 48,
                        child: RaisedButton.icon(
                          color: Colors.white,
                          elevation: 0,
                          shape: shape1,
                          onPressed: () {
                            checkInternet(context).then((value) async {
                              if (value == 'ok') {
                                setState(() {
                                  loading=true;
                                });
                              await  loginWithGoogle(context, widget.bLoC).then((value){
                                  setState(() {
                                    loading=false;
                                  });
                                });
                              }
                            });
                          },
                          icon: Icon(FontAwesomeIcons.google),
                          label: Padding(
                            padding:
                            const EdgeInsets.only(right: 2.0, left: 2.0),
                            child: Text(
                              getTranslated(context, "google_login"),
                              style: button2TextLogin,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //         if(Platform.isIOS)    SizedBox(
                    //   height: 10,
                    // ),
                    // if(Platform.isIOS)  Center(
                    //   child: SizedBox(
                    //     width: MediaQuery.of(context).size.width / 1.1,
                    //     height: 48,
                    //     child: RaisedButton.icon(
                    //       color: Colors.white,
                    //       elevation: 0,
                    //       shape: shape1,
                    //       onPressed: () {
                    //         checkInternet(context).then((value) async {
                    //           if (value == 'ok') {
                    //             setState(() {
                    //               loading=true;
                    //             });
                    //             await  loginWithApple(context, widget.bLoC).then((value){
                    //               setState(() {
                    //                 loading=false;
                    //               });
                    //             });
                    //           }
                    //         });
                    //       },
                    //       icon: Icon(FontAwesomeIcons.apple),
                    //       label: Padding(
                    //         padding:
                    //         const EdgeInsets.only(right: 2.0, left: 2.0),
                    //         child: Text(
                    //           getTranslated(context, "apple_login"),
                    //           style: button2TextLogin,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                        onPressed: () async {
                          SharedPreferences pref =
                          await SharedPreferences.getInstance();
                          pref.setString("skipLogin", "1");
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: HomeScreen(
                                    bLoC: widget.bLoC,
                                  )));
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(getTranslated(context, "skip_login"),
                                style: hintTextInput),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getPhoneNumber(String input) {
    if(countryCode=='+964'){
    if (input.length >= 10) {
      String first = input.substring(0, 1);
      if (first == "0") input = input.substring(1);
      String nat = input.substring(0, 2);
      if (nat == "75" || nat == "77" || nat == "78" || nat == "79") {
        return "+964" + input;
      }
    }
    }
    else{
      return countryCode + input;
    }
    return "";
  }
  Future<void> phoneSignIn({@required String phoneNumber}) async {
    print(phoneNumber);
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    setState(() {
      loading = true;
    });
    await FirebaseAuth.instance
        .signInWithCredential(authCredential).then((value) async {
      setState(() {
        loading = false;
      });
      if (value.user.phoneNumber != null) {
        await loginWithPhone(getPhoneNumber(phoneNo)).then((value) {
          if(value==true){
            showTopFlash(context, getTranslated(context, 'login_successfully'), '', false);
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(
                      bLoC: widget.bLoC,)), (
                route) => false);
          }
          else{
            showTopFlash(context, getTranslated(context, 'login_error'), '', true);
          }
        });
      }
    });
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showTopFlash(context, '', '"The phone number entered is invalid!"', false);
    }
  }

  _onCodeSent(String verificationId, int forceResendingToken) {
    this.verificationId = verificationId;
    print(verificationId);
    setState(() {
      this.verificationId = verificationId;
    });
    print("code sent");
  }

  _onCodeTimeout(String timeout) {
    return null;
  }
  Future<bool> confirmPhoneFromAppDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                     getTranslated(context, 'are_you_sure_phone'),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                         "${countryCode+phoneController.text.trim().toString()}",
                    style: TextStyle(fontSize: 17, color: Colors.teal),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.grey[800],
                          child: Text(
                            getTranslated(context, 'no'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton(
                          color: Colors.teal[300],
                          child: Text(getTranslated(context, 'yes'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
                              await phoneSignIn(phoneNumber: getPhoneNumber(
                                  phoneController.text.toString()));
                              Navigator.of(context).pop();
                              setState(() {
                                this.codeSent = true;
                                this.phonePage = false;
                              });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
