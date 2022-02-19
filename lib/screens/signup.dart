import 'package:dijlah_store_ibtechiq/service/registration_api.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:dijlah_store_ibtechiq/screens/signup_as_seller_new_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
class SignUp extends StatefulWidget {
  final BLoC bLoC;

  const SignUp({Key key, this.bLoC}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var statusVer;
  var msgVer;
  bool loading = false;

  @override
  void initState() {
    checkInternet(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getTranslated(context, "sign_up"),style: loginTitleStyle1,),
                        SizedBox(height: 5),
                        Text(getTranslated(context, "continue_sign_up"),style:loginTitleStyle2,),

                      ],
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignUpAsSellerNewUser(bLoC: widget.bLoC,)), (route) => false);
                        },
                        child: SizedBox(child: Text(getTranslated(context, "sign_up_as_seller"),style: loginTitleStyle3,)))
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:16.0,left: 16),
                          child: Text(getTranslated(context, "full_name"),style:labelTextInput,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:16.0,right: 16,top: 8),
                          child: TextFormField(
                            controller: fullNameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(context, "full_name_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration:inputDecoration(getTranslated(context, "full_name_hint"))),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:16.0,left: 16),
                          child: Text(getTranslated(context, "email"),style: labelTextInput,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:16.0,right: 16,top: 8),
                          child: TextFormField(
                            controller: emailController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(context, "email_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration:inputDecoration(getTranslated(context, "email_hint"))),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:16.0,left: 16),
                          child: Text(getTranslated(context, "password"),style: labelTextInput,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:16.0,right: 16,top: 8),
                          child: TextFormField(
                              obscureText: true,
                            controller: passwordController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(context, "password_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.visiblePassword,
                              decoration: inputDecoration(getTranslated(context, "password_hint"))),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:16.0,left: 16),
                          child: Text(getTranslated(context, "confirm_password"),style: labelTextInput,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:16.0,right: 16,top: 8),
                          child: TextFormField(
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(context, "confirm_password_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.visiblePassword,
                            controller: confirmPasswordController,
                              decoration:inputDecoration(getTranslated(context, "confirm_password_hint"))),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width/1.1,
                        height:48,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [Color(0xff86f7b6), Color(0xff8fd3f1)],
                            ),
                          ),
                          child: RaisedButton(
                            color: Colors.transparent,
                            elevation: 0,
                            onPressed: () async {

                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading=true;
                                  });
                                  bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(emailController.text
                                      .toString());
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  if (emailValid == true) {
                                    if (passwordController.text
                                        .toString() ==
                                        confirmPasswordController.text
                                            .toString()) {
                                      checkInternet(context).then((value) async {
                                      if(value=='ok') {
                                      await signUp(
                                          emailController.text.trim(),
                                          fullNameController.text.trim(),
                                          passwordController.text.trim());
                                        SharedPreferences pref =
                                        await SharedPreferences
                                            .getInstance();
                                        var message=pref.getString("messages");
                                        var result=pref.getString("result");
                                        if (result=='true'&&message =="Registration Successful. Please verify and log in to your account." && result=='true' ) {
                                          setState(() {
                                            loading=false;
                                          });
                                          Navigator.pushAndRemoveUntil(
                                              context, MaterialPageRoute(
                                              builder:
                                                  (context) {
                                                return HomeScreen(
                                                  bLoC: widget.bLoC,
                                                );
                                              }), (route) => false);
                                          showTopFlash(context,"",  getTranslated(context, "sign_up_successfully"),false);
                                        }
                                        else if(result=='false'&&message=="User already exists.") {
                                          setState(() {
                                            loading=false;
                                          });
                                          showTopFlash(context,"",  getTranslated(context, "email_exist"),true);
                                        }
                                        else{
                                          setState(() {
                                            loading=false;
                                          });
                                          showTopFlash(context,"",  getTranslated(context, "error_update_user_info"),true);
                                        }
                                    } else {
                                      setState(() {
                                        loading=false;
                                      });
                                      showTopFlash(context,"",  getTranslated(context, "password_no_match"),true);
                                    }
                                  });}}
                                  else {
                                    setState(() {
                                      loading=false;
                                    });
                                    showTopFlash(context,"",  getTranslated(context, "wrong_email_format"),true);
                                  }
                                }
                            },
                            child: loading?SizedBox(width:20,height:20,child: CircularProgressIndicator()): Text(getTranslated(context, "sign_up"),style: buttonTextLogin,),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: () async {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login(bLoC: widget.bLoC,)), (route) => false);
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  getTranslated(context, "have_account"),
                                  style: hintTextInput
                              ),
                              SizedBox(width: 3,),
                              Text(
                                  getTranslated(context, "login_now"),
                                  style: loginTitleStyle3.copyWith(fontSize: 14)
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 10,),
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
