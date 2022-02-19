import 'dart:convert';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class AddReview extends StatefulWidget {
  final title;
  final productId;
  final BLoC bLoC;
  const AddReview({Key key, this.title, this.productId, this.bLoC}) : super(key: key);
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  bool isReview=false;
  bool isLoading=true;
  bool loading=false;
  var rating=0.0;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController commentTextController = new TextEditingController();
  var message;
  @override
  void initState() {
    checkInternet(context).then((value) async {
      if(value=='ok') {
        checkIsProductReview().then((value) =>
            setState(() {
              isLoading = false;
            }));
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: appBarTitle(getTranslated(context, "review_product")),
        titleSpacing: 0.0,
        leading: backArrow(context),
        centerTitle: false,
      ),
      body:isLoading?Center(child: SizedBox(width:30,height:30,child: CircularProgressIndicator())):isReview==true?Column(
        children: [
          SizedBox(height: 30,),
          Text(widget.title),
          SizedBox(height: 30,),
          Center(child: Container(child: Text(getTranslated(context, 'product_reviewed'),))),
        ],
      ):Container(
       child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                         Text(widget.title),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Text(getTranslated(context, "review_product"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                    SmoothStarRating(
                        allowHalfRating: true,
                        onRated: (v) {
                          setState(() {
                            rating=v;
                          });
                        },
                        starCount: 5,
                        rating: rating,
                        size: 33.0,
                        isReadOnly:false,
                        color: Colors.yellow[700],
                        filledIconData:Icons.star_rate_rounded,
                        halfFilledIconData: Icons.star_half_rounded,
                        defaultIconData: Icons.star_border_rounded,
                        borderColor: Colors.yellow[700],
                        spacing:10.0
                    ),
                  ],
                ),
                     SizedBox(height: 20,),
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
                    controller: commentTextController,
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
                SizedBox(height: 30,),
                SizedBox(
                  height: SizerUtil.deviceType == DeviceType.tablet?4.h:5.h,
                  width: SizerUtil.deviceType == DeviceType.tablet?94.w:94.w,
                  child: RaisedButton(
                    elevation: 0,
                    color: Colors.teal[200],
                    onPressed: () async {
                      if (_form.currentState.validate()) {
                      checkInternet(context).then((value) async {
                        if (value == 'ok') {

                          await addProductReview().then((value){
                          if (value ==
                              "Review has been submitted successfully") {
                            setState(() {
                              isLoading = true;
                              loading = false;
                            });
                            checkIsProductReview().then((value) =>
                                setState(() {
                                  isLoading = false;
                                }));
                            return showTopFlash(context, "",
                                getTranslated(context, "review_successfully"),
                                false);
                          } else {
                            setState(() {
                              loading = false;
                            });
                            return showTopFlash(context, "",
                                getTranslated(context, "call_us_error"), false);
                          }
                        });
                      }});
                    }
                  },child: loading?SizedBox(width:20,height:20,child: CircularProgressIndicator()):Text(getTranslated(context, 'add_review')),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkIsProductReview() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("userId");
    var userToken = preferences.getString("access_token");
    if (userId != null) {
      String url = MAIN_URL + "reviews/isReviwed";
      Map<String, String> body = {
        "user_id": userId,
        "product_id": widget.productId.toString()
      };
      Response response = await post(Uri.parse(url), body: body, headers: {"Authorization": "Bearer " + userToken});
      print(response.body);
      var data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          this.isReview = data['is_in_Review'];
        });
      }
    }
  }
 Future addProductReview() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("userId");
    var userToken = preferences.getString("access_token");
    if (userId != null) {
      String url = MAIN_URL + "reviews/add";
      Map<String, String> body = {
        "user_id": userId,
        "product_id": widget.productId.toString(),
        "rating":rating.toString(),
        "comment":commentTextController.text.toString().trim(),
      };
      Response response = await post(Uri.parse(url), body: body, headers: {"Authorization": "Bearer " + userToken});
      print(response.body);
      var data = jsonDecode(response.body);
      return data['message'];

    }
  }
}
