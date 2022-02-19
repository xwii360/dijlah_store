import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/service/registration_api.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'login_as_seller.dart';

class SignUpAsSellerNewUser extends StatefulWidget {
  final BLoC bLoC;

  const SignUpAsSellerNewUser({Key key, this.bLoC}) : super(key: key);
  @override
  _SignUpAsSellerNewUserState createState() => _SignUpAsSellerNewUserState();
}

class _SignUpAsSellerNewUserState extends State<SignUpAsSellerNewUser> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController shopNameTextController = new TextEditingController();
  TextEditingController addressTextController = new TextEditingController();
  TextEditingController shopTypeTextController = new TextEditingController();
  TextEditingController phoneTextController = new TextEditingController();
  var selectedVendorType='vendor';
  var selectedCountry='بغداد';
  bool loading = false;
  String value;
  var vendorType=["vendor","single","company"];
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
              SizedBox(height: 90),
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
                          getTranslated(context, "sign_up_as_seller"),
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
                          getTranslated(context, "login"),
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
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, left: 16),
                          child: Text(
                            getTranslated(context, "full_name"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextFormField(
                              controller: fullNameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(
                                      context, "full_name_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: inputDecoration(
                                  getTranslated(context, "full_name_hint"))),
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
                            getTranslated(context, "email"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(
                                      context, "email_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
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
                            getTranslated(context, "phone"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextFormField(
                              controller: phoneTextController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(
                                      context, "phone_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: inputDecoration(
                                  getTranslated(context, "phone_hint"))),
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
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(
                                      context, "password_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.visiblePassword,
                              decoration: inputDecoration(
                                  getTranslated(context, "password_hint"))),
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
                            getTranslated(context, "confirm_password"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextFormField(
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(context,
                                      "confirm_password_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.visiblePassword,
                              controller: confirmPasswordController,
                              decoration: inputDecoration(getTranslated(
                                  context, "confirm_password_hint"))),
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
                            getTranslated(context, "shop_name"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(
                                      context, "shop_name_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              controller: shopNameTextController,
                              decoration: inputDecoration(
                                  getTranslated(context, "shop_name_hint"))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, left: 16),
                          child: Text(
                            getTranslated(context, "state_hint"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextField(
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              readOnly: true,
                              onTap: ()=>showOptionsState(context),
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors.black12.withOpacity(0.01))),
                                contentPadding:EdgeInsets.only(left:10.0,right: 10.0,top: SizerUtil.deviceType == DeviceType.tablet?20:13,bottom: SizerUtil.deviceType == DeviceType.tablet?20:13),
                                hintText:selectedCountry,
                                hintStyle:
                                TextStyle(fontFamily: "sans", fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, left: 16),
                          child: Text(
                            getTranslated(context, "address"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(
                                      context, "address_required_filed");
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              controller: addressTextController,
                              maxLines: 6,
                              decoration: inputDecoration(
                                  getTranslated(context, "address_hint"))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, left: 16),
                          child: Text(
                            getTranslated(context, "vendor_type"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: TextField(
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              readOnly: true,
                              onTap: ()=>showOptionsVendor(context),
                              style: TextStyle(
                                  fontFamily: "sans",
                                  fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors.black12.withOpacity(0.01))),
                                contentPadding:EdgeInsets.only(left:10.0,right: 10.0,top: SizerUtil.deviceType == DeviceType.tablet?20:13,bottom: SizerUtil.deviceType == DeviceType.tablet?20:13),
                                hintText:getTranslated(context, selectedVendorType),
                                hintStyle:
                                TextStyle(fontFamily: "sans", fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp),
                              )),
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
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [Color(0xff86f7b6), Color(0xff8fd3f1)],
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(emailController.text.toString());
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                if (emailValid == true) {
                                  if (passwordController.text.toString() ==
                                      confirmPasswordController.text
                                          .toString()) {
                                    checkInternet(context).then((value) async {
                                      if (value == 'ok') {
                                        await signUpSeller(
                                                fullNameController.text,
                                                shopNameTextController.text,
                                                addressTextController.text,
                                                emailController.text,
                                                passwordController.text,
                                                phoneTextController.text,
                                                selectedVendorType,
                                                selectedCountry)
                                            .then((value) {
                                          if (value ==
                                              "Seller has been inserted successfully") {
                                            setState(() {
                                              loading = false;
                                            });
                                            Navigator.pushAndRemoveUntil(
                                                context, MaterialPageRoute(
                                                    builder: (context) {
                                              return LoginAsSeller(
                                                bLoC: widget.bLoC,
                                              );
                                            }), (route) => false);
                                            showTopFlash(
                                                context,
                                                "",
                                                getTranslated(context,
                                                    "shop_add_new_user_successfully"),
                                                false);
                                          } else if (value ==
                                              "Email already exists!") {
                                            setState(() {
                                              loading = false;
                                            });
                                            showTopFlash(
                                                context,
                                                "",
                                                getTranslated(
                                                    context, "email_exist"),
                                                true);
                                          } else {
                                            setState(() {
                                              loading = false;
                                            });
                                            showTopFlash(
                                                context,
                                                "",
                                                getTranslated(context,
                                                    "error_update_user_info"),
                                                true);
                                          }
                                        });
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    showTopFlash(
                                        context,
                                        "",
                                        getTranslated(
                                            context, "password_no_match"),
                                        true);
                                  }
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  showTopFlash(
                                      context,
                                      "",
                                      getTranslated(
                                          context, "wrong_email_format"),
                                      true);
                                }
                              }
                            },
                            child: loading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator())
                                : Text(
                                    getTranslated(context, "sign_up"),
                                    style: buttonTextLogin,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
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

  void showOptionsState(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(children: [
                 ListTile(
                  title: Text(
                   getTranslated(context, 'choose_state'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded))),
              ]),
              Container(
                height: 1,
                decoration:  BoxDecoration(color: Colors.grey[200]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                      children:statesAr.map((e) =>
                          ListTile(
                              onTap: () {
                                setState(() {
                                  selectedCountry=e;
                                });
                                Navigator.pop(context);
                              },
                              title: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: selectedCountry==e?Theme.of(context).primaryColor:Colors.grey[300],width:  selectedCountry==e?1.5:1)),
                                child: Row(
                                  children: [
                                    Text(
                                      e,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                          ),
                      ).toList()
                  ),
                ),
              ),
            ],
          );
        });
  }
  void showOptionsVendor(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(children: [
                 ListTile(
                  title: Text(
                   getTranslated(context, 'choose_state'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded))),
              ]),
              Container(
                height: 1,
                decoration:  BoxDecoration(color: Colors.grey[200]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                      children:vendorType.map((e) =>
                          ListTile(
                              onTap: () {
                                setState(() {
                                  selectedVendorType=e;
                                });
                                Navigator.pop(context);
                              },
                              title: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: selectedVendorType==e?Theme.of(context).primaryColor:Colors.grey[300],width:  selectedVendorType==e?1.5:1)),
                                child: Row(
                                  children: [
                                    Text(
                                     getTranslated(context, e) ,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                          ),
                      ).toList()
                  ),
                ),
              ),
            ],
          );
        });
  }
}
