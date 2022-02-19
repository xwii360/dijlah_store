import 'dart:convert';
import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  final BLoC bLoC;
  final getFrom;
  UpdateProfile({this.bLoC, this.getFrom});
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countyController = TextEditingController();
  String msg = '';
  String name = '';
  String phone = '';
  String email = '';
  String country = '';
  String type='';
  bool loading=false;
  @override
  void initState() {
    checkInternet(context);
    getPhone().then((updatePhone));
    getName().then((updateName));
    getEmail().then((updateEmail));
    getCountry().then((updateCountry));
    getLoginType().then((updateLoginType));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
            title: appBarTitle(getTranslated(context, "update_user_info")),
             leading: backArrow(context),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8),
                      child: Text(getTranslated(context, 'profile_description'),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey),),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8),
                          child: Text(
                            getTranslated(context, "full_name"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 8),
                            child: TextFormField(
                              controller: nameController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(context, 'full_name_required');
                                }
                                return null;
                              },
                              decoration: inputDecoration(name == ''
                                  ? getTranslated(context, "full_name_hint")
                                  : name),
                            )),
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
                          padding: const EdgeInsets.only(right: 8.0, left: 8),
                          child: Text(
                            getTranslated(context, "phone"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 8),
                            child: TextFormField(
                              controller: phoneController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              enabled: type=='phone'?false:true,
                              autocorrect: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(context, 'phone_required');
                                }
                                return null;
                              },
                              decoration: inputDecoration(phone == ''
                                  ? getTranslated(context, "phone_hint")
                                  : phone),
                            )),
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
                          padding: const EdgeInsets.only(right: 8.0, left: 8),
                          child: Text(
                            getTranslated(context, "email"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 8),
                            child: TextFormField(
                              controller: emailController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              enabled: type=='facebook'||type=='seller'||type=='google'?false:true,
                              autocorrect: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return getTranslated(context, 'email_required');
                                }
                                return null;
                              },
                              decoration: inputDecoration(email == ''
                                  ? getTranslated(context, "email_hint")
                                  : email),
                            )),
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
                          padding: const EdgeInsets.only(right: 8.0, left: 8),
                          child: Text(
                            getTranslated(context, "state_hint"),
                            style: labelTextInput,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 8),
                            child: TextField(
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              readOnly: true,
                              onTap: ()=>showOptions(context),
                              decoration: inputDecoration(country == ''
                                  ? getTranslated(context, "state_hint")
                                  : country),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 300,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(
                                  color: Colors.teal[400], width: 1.4)),
                          elevation: 0,
                          color: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                                  checkInternet(context).then((value) async {
                                    if (value == 'ok') {
                                      setState(() {loading=true;});
                                      await updateUserInfo(name,phone,email).then((value) => setState(() {loading=false;}));
                                      if (msg ==
                                          "Profile information has been updated successfully") {
                                        setState(() {loading=false;});
                                        showTopFlash(
                                            context,
                                            "",
                                            getTranslated(context,
                                                "update_user_info_successfully"),
                                            false);
                                        if(widget.getFrom=='home'){
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return HomeScreen(bLoC: widget.bLoC);
                                                  }));
                                        }
                                        else {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return Settings(
                                                        bLoC: widget.bLoC);
                                                  }));
                                        }
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        preferences.setString(
                                            "name",
                                            nameController.text.trim().isEmpty
                                                ? name.toString().isEmpty
                                                    ? ""
                                                    : name
                                                : nameController.text.trim());
                                        preferences.setString(
                                            "phone",
                                            phoneController.text.trim().isEmpty
                                                ? phone.toString().isEmpty
                                                ? ""
                                                : phone
                                                : phoneController.text.trim());
                                        preferences.setString(
                                            "email",
                                            emailController.text.trim().isEmpty
                                                ? email.toString().isEmpty
                                                ? ""
                                                : email
                                                : emailController.text.trim());
                                        preferences.setString(
                                            "country", country);
                                      }
                                      else if(msg == "phone already exists."){
                                        setState(() {loading=false;});
                                        showTopFlash(
                                            context,
                                            "",
                                            getTranslated(context,
                                                "phone_number_exist"),
                                            true);
                                      }
                                      else if(msg == "email already exists."){
                                        setState(() {loading=false;});
                                        showTopFlash(
                                            context,
                                            "",
                                            getTranslated(context,
                                                "email_exist"),
                                            true);
                                      }
                                      else {
                                        setState(() {loading=false;});
                                        showTopFlash(
                                            context,
                                            "",
                                            getTranslated(context,
                                                "error_update_user_info"),
                                            true);
                                      }
                                }
                              });
                            }
                          },
                          child: loading?SizedBox(width:20,height:20,child: CircularProgressIndicator()):Text(
                            getTranslated(context, "update"),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sans",
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: widget.getFrom=='home'?Container(height: 0,): bottomNavigatorBar(context, 4, widget.bLoC, false)),
    );
  }
  Future<bool> updateUserInfo(name,phone,email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user_token = preferences.getString("access_token");
    var user_id = preferences.getString("userId");
    String url = MAIN_URL + "user/info/update";
    var finalName = nameController.text.trim().isEmpty
        ? name.toString().isEmpty
            ? ""
            : name
        : nameController.text.trim();
    var finalPhone = phoneController.text.trim().isEmpty
        ? phone.toString().isEmpty
        ? ""
        : phone
        : phoneController.text.trim();
    var finalEmail = emailController.text.trim().isEmpty
        ? email.toString().isEmpty
        ? ""
        : email
        : emailController.text.trim();
    Map<String, String> body = {
      'user_id': user_id,
      'name': finalName??'',
      'phone': finalPhone??'',
      'email': finalEmail??'',
      'country': country,
    };
    Response response = await post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + user_token
        },
        body: body);
    print(response.body);
      var data = jsonDecode(response.body);
      print(data);
      String msg = data['message'];
      setState(() {
        this.msg = msg;
      });
      return true;
  }
  void showOptions(context) {
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
                    children: statesAr.map((e) =>
                      ListTile(
                          onTap: () {
                            setState(() {
                             country=e;
                            });
                            Navigator.pop(context);
                          },
                          title: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: country==e?Theme.of(context).primaryColor:Colors.grey[300],width:  country==e?1.5:1)),
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
  Future<String> getLoginType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String type = sharedPreferences.getString("login_type");
    if (type == null) {
      return "";
    } else
      return type;
  }
  Future<String> getCountry() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String country = sharedPreferences.getString("country");
    if (country == null) {
      return "";
    } else
      return country;
  }

  updatePhone(String phone) {
    setState(() {
      this.phone = phone;
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
  updateLoginType(String type) {
    setState(() {
      this.type = type;
    });
  }


}
