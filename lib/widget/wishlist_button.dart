import 'dart:convert';
import 'package:dijlah_store_ibtechiq/screens/login.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
class WishListButton extends StatefulWidget {
  final productId;
  final productName;
  final BLoC bLoC;
  final fromCart;
  const WishListButton(
      {Key key,
      this.productId,
      this.bLoC,
      this.fromCart = false,
      this.productName})
      : super(key: key);

  @override
  _WishListButtonState createState() => _WishListButtonState();
}

class _WishListButtonState extends State<WishListButton> {
  var isWishList;
  String wishListId;
  bool isLoading = false;
  @override
  void initState() {
    checkIsProductInWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        var token = pref.getString("access_token");
        var userId = pref.getString("userId");
        if (token == null && userId == null) {
          showTopFlash(context, '',
              getTranslated(context, "login_before_add_to_wish_list"), false);
         Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:  Login(
                        bLoC: widget.bLoC,
                      )));
        } else {
          setState(() {
            isLoading=true;
          });
          if (isWishList == "false") {
            addToWishList().then((value) {
              setState(() {
                isLoading=false;
              });
            });
          } else {
            setState(() {
              isLoading=true;
            });
            deleteWishList().then((value) {
              setState(() {
                isLoading=false;
              });
            });
          }
        }
      },
      child: Row(
        children: [
          isLoading
              ? SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ))
              : widget.fromCart
                  ? Icon(
                      isWishList == "true"
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: isWishList == "true"
                          ? Colors.red[500]
                          : Colors.grey[500],
                      size: SizerUtil.deviceType == DeviceType.tablet ? 32 : 22,
                    )
                  : Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Color(0xfff7f7f9),
                          borderRadius: BorderRadius.circular(100)),
                      child: isLoading
                          ? SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ))
                          : Icon(
                              isWishList == "true"
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              color: isWishList == "true"
                                  ? Colors.red[500]
                                  : Colors.grey[500],
                              size: 22,
                            ),
                    ),
          SizedBox(
            width: 3,
          ),
          if (widget.fromCart)
            Text(
              getTranslated(context, "add_to_wish_list"),
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize:
                      SizerUtil.deviceType == DeviceType.tablet ? 6.sp : 11.sp),
            )
        ],
      ),
    );
  }

  checkIsProductInWishList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("userId");
    var userToken = preferences.getString("access_token");
    if((userToken!=null && userId!=null) ) {
      String url = MAIN_URL + "wishlists/check-product";
      Map<String, String> body = {
        "user_id": userId,
        "product_id": widget.productId.toString(),
      };

      Response response = await post(
          Uri.parse(url),
        body: body,
          headers: {"Authorization": "Bearer " + userToken}
      );
      print(response.body);
      var data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          this.isWishList = data['is_in_wishlist'].toString();
          this.wishListId = data['wishlist_id'].toString();
        });
      }
    }
  }

  Future<String> addToWishList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("userId");
    var userToken = preferences.getString("access_token");
    if((userToken!=null && userId!=null) ) {
      String url = MAIN_URL + "wishlists";
      Map<String, String> body = {
        "user_id": userId,
        "product_id": widget.productId.toString()
      };
      Response response = await post(
          Uri.parse(url),
        body: body,
          headers: {"Authorization": "Bearer " + userToken}
      );
      print(response.body);
      var data = jsonDecode(response.body);
      if (data['message'] == "Product is successfully added to your wishlist") {
        if (mounted) {
          setState(() {
            this.isWishList = 'true';
          });
          checkIsProductInWishList();
          widget.bLoC.getAllWishListFuture();
        }
        showTopFlash(context, widget.productName,
            getTranslated(context, "add_to_wishlist"), false);
      } else {
        showTopFlash(context, widget.productName,
            getTranslated(context, "wishlist_error"), true);
      }
      return data['message'];
    }
  }

  Future<String> deleteWishList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString("access_token");
    if((userToken!=null ) ||(userToken!='' )||(userToken.isNotEmpty ) ) {
      String url = MAIN_URL + "wishlists/${wishListId}";
      Response response = await delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer " + userToken},
      );
      print(response.body);
      var data = jsonDecode(response.body);
      if (data['message'] ==
          "Product is successfully removed from your wishlist") {
        if (mounted) {
          setState(() {
            this.isWishList = 'false';
          });
          checkIsProductInWishList();
          widget.bLoC.getAllWishListFuture();
        }
        showTopFlash(context, widget.productName,
            getTranslated(context, "delete_from_wishlist"), false);
      } else {
        showTopFlash(context, widget.productName,
            getTranslated(context, "wishlist_error"), true);
      }
      return data['message'];
    }
  }
}
