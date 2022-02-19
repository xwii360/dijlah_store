import 'package:dijlah_store_ibtechiq/screens/login.dart';
import 'package:dijlah_store_ibtechiq/screens/signup_as_seller_new_user.dart';
import 'package:dijlah_store_ibtechiq/service/registration_api.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAsSeller extends StatefulWidget {
  final BLoC bLoC;
  const LoginAsSeller({Key key, this.bLoC}) : super(key: key);
  @override
  _LoginAsSellerState createState() => _LoginAsSellerState();
}

class _LoginAsSellerState extends State<LoginAsSeller> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  bool loading = false;
  @override
  void initState() {
    checkInternet(context);
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
                                  builder: (context) => SignUpAsSellerNewUser(
                                    bLoC: widget.bLoC,
                                  )),
                                  (route) => false);
                        },
                        child: Text(
                          getTranslated(context, "sign_up_as_seller"),
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
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, left: 16),
                          child: Text(
                            getTranslated(context, "email"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(
                                      context, "email_required_filed");
                                }
                                return null;
                              },
                              decoration: inputDecoration(
                                  getTranslated(context, "email_hint"))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, left: 16),
                          child: Text(
                            getTranslated(context, "password"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(
                                      context, "password_required_filed");
                                }
                                return null;
                              },
                              decoration: inputDecoration(
                                  getTranslated(context, "password_hint"))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
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
                            onPressed: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.setString(
                                  "login_type", 'seller');
                              checkInternet(context).then((value) async {
                                if (value == 'ok') {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(
                                            emailController.text.toString());
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    if (emailValid == true) {
                                      await login(
                                        emailController.text.toString(),
                                        passwordController.text.toString(),
                                      );
                                      var message = pref.getString("message");
                                      var result = pref.getString("result");
                                      var user = pref.getString("user");
                                      if (message == "Successfully logged in" &&
                                          result == 'true') {
                                        setState(() {
                                          loading = false;
                                        });
                                        pref.remove("skipLogin");
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(
                                                      bLoC: widget.bLoC,
                                                    )),
                                            (route) => false);
                                        showTopFlash(context,"",    getTranslated(
                                            context, "login_successfully"),false);
                                      } else if (message == "Unauthorized" &&
                                          result == 'false') {
                                        setState(() {
                                          loading = false;
                                        });
                                        showTopFlash(context,"", getTranslated(
                                            context, "wrong_login"),true);
                                      } else if (message == "User not found" &&
                                          result == 'false') {
                                        setState(() {
                                          loading = false;
                                        });
                                        showTopFlash(context,"",
                                            getTranslated(
                                                context, "email_not_found"),true);

                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                        showTopFlash(context,"", getTranslated(
                                            context, "login_error"),true);
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    showTopFlash(context,"", getTranslated(
                                        context, "wrong_email_format"),true);
                                  }
                                }
                              });
                            },
                            child: loading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator())
                                : Text(
                                    getTranslated(context, "login"),
                                    style: buttonTextLogin,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                        onPressed: () async {
                          Navigator.pushReplacement(context, PageTransition(type:PageTransitionType.fade, child:  Login(
                            bLoC: widget.bLoC,
                          )));
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(getTranslated(context, "login_as_customer"),
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
}
