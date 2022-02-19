import 'dart:convert';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';
class CallUs extends StatefulWidget {
  final BLoC bLoC;

  const CallUs({Key key, this.bLoC}) : super(key: key);

  @override
  _CallUsState createState() => _CallUsState();
}

class _CallUsState extends State<CallUs> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController nameTextController = new TextEditingController();
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController problemTextController = new TextEditingController();
  TextEditingController phoneTextController = new TextEditingController();
  String  selectedNoteType='note';
  var status;
  var noteType=["suggestion","note"];

  bool loading=false;
  @override
  void initState() {
    checkInternet(context);
    super.initState();
  }
@override
  void setState(fn) {
  selectedNoteType = getTranslated(context, "note");
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
         backgroundColor: Colors.white,
         elevation: 0,
         automaticallyImplyLeading: false,
         title: appBarTitle(getTranslated(context, "call_us")),
         titleSpacing: 0.0,
         leading: backArrow(context),
         centerTitle: false,
       ),
      body: Padding(
        padding: EdgeInsets.only(right: 12.0, left: 12.0, top: 15.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(width: 1.2, color: Colors.red[100])),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  getTranslated(context, "call_us_title"),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize:  SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp,
                      letterSpacing: 1.2,
                      fontFamily: "sans"),
                ),
              ),
            ),
            Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                      getTranslated(context, "full_name"),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize:SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp,
                        fontFamily: "sans"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return  getTranslated(context, "full_name_required_filed");
                      }
                    },
                    controller: nameTextController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
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

                      hintText:  getTranslated(context, "full_name_hint"),
                      hintStyle:
                      TextStyle(fontFamily: "sans", fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text( getTranslated(context, "email"),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize:SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp,
                          fontFamily: "sans")),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return getTranslated(context, "email_required_filed");
                      }
                    },
                    controller: emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.words,
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

                      hintText: getTranslated(context, "email_hint"),
                      hintStyle:
                      TextStyle(fontFamily: "sans", fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(getTranslated(context, "phone_number"),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp,
                          fontFamily: "sans")),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return getTranslated(context, "phone_number_required_filed");
                      }
                    },
                    controller: phoneTextController,
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.words,
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
                      hintText: getTranslated(context, "phone_number_hint"),
                      hintStyle:
                      TextStyle(fontFamily: "sans", fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(getTranslated(context, "note_type"),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp,
                        fontFamily: "sans",
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    readOnly: true,
                    onTap: ()=>showOptions(context),
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
                        hintText:getTranslated(context, selectedNoteType),
                        hintStyle:
                        TextStyle(fontFamily: "sans", fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(getTranslated(context, "note"),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp,
                        fontFamily: "sans",
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return getTranslated(context, "note_feild_is_required");
                        }
                      },
                      maxLines:  SizerUtil.deviceType == DeviceType.tablet?8:6,
                      controller: problemTextController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
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

                        hintText:getTranslated(context, "note_hint"),
                        hintStyle:
                        TextStyle(fontFamily: "sans", fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_form.currentState.validate()) {
                        checkInternet(context).then((value) async {
                          if (value == 'ok') {
                            var email = emailTextController.text.trim();
                            bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email);
                            FocusScope.of(context).requestFocus(
                                new FocusNode());
                            if (emailValid == true) {
                              setState(() {loading=true;});
                              await insertCallUs().then((value) => setState(()=>loading=false));
                              if (status == true) {
                                setState(() {
                                  loading=false;
                                });
                                showTopFlash(context, "", getTranslated(
                                    context, "call_us_successfully"), false);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return Settings(bLoC: widget.bLoC);
                                    }));
                              } else {
                                setState(() {
                                  loading=false;
                                });
                                showTopFlash(context, "", getTranslated(
                                    context, "wrong_email_format"), true);
                              }
                            } else {
                              setState(() {
                                loading=false;
                              });
                              showTopFlash(context, "",
                                  getTranslated(context, "call_us_error"),
                                  true);
                            }
                          }
                        });
                      }
                    },
                    child: Container(
                      height: SizerUtil.deviceType == DeviceType.tablet?70:52.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: color1,
                          borderRadius:
                          BorderRadius.all(Radius.circular(40.0))),
                      child: Center(
                        child: loading?SizedBox(width:20,height:20,child: CircularProgressIndicator()):Text(
                         getTranslated(context, "send"),
                          style: TextStyle(
                              fontFamily: "sans",
                              color: Colors.white,
                              fontSize: SizerUtil.deviceType == DeviceType.tablet?6.sp:12.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> insertCallUs() async {
    String url = MAIN_URL2 + "insertCallUs";
    Map<String, String> body = {
      'name': nameTextController.text.toString(),
      'email': emailTextController.text.toString(),
      'note': problemTextController.text.toString(),
      'phone': phoneTextController.text.toString(),
      'type': selectedNoteType.toString(),
    };
    Response response = await post(Uri.parse(url),
        headers: {"Accept": "application/json"}, body: body);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      bool status = data['status'];
      setState(() {
        this.status = status;
      });
      return true;
    } else {
      throw "حدث خطأ ما اثناء جلب المعلومات";
    }
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
                    getTranslated(context, 'choose_note_type'),
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
                height: MediaQuery.of(context).size.width/2.5,
                child: SingleChildScrollView(
                  child: Column(
                      children: noteType.map((e) =>
                          ListTile(
                              onTap: () {
                                setState(() {
                                  selectedNoteType=e;
                                });
                                Navigator.pop(context);
                              },
                              title: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: selectedNoteType==e?Theme.of(context).primaryColor:Colors.grey[300],width:  selectedNoteType==e?1.5:1)),
                                child: Row(
                                  children: [
                                    Text(
                                      getTranslated(context, e),
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