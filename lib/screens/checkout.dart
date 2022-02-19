import 'dart:collection';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/model/states.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/cartItem.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'confirm_order.dart';

class CheckOut extends StatefulWidget {
  final BLoC bLoC;
  final List<CartItem> cartItem;
  final grandTotal;
  const CheckOut({Key key, this.bLoC, this.cartItem, this.grandTotal})
      : super(key: key);
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController couponController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  bool isLoading = false;
  bool appliedCoupon=false;
  bool loadingCoupon=false;
  var grand_total = 0;
  var shipping_cost = 5000;
  bool success;
  int discount = 0;
  String message;
  String name = '';
  String email = '';
  String phone = '';
  List<String> states = [
    'الأنبار',
    'بابل',
    'بغداد',
    'البصرة',
    'ذي قار',
    'ديالى',
    'دهوك',
    'أربيل',
    'كربلاء',
    'كركوك',
    'ميسان',
    'المثنى',
    'النجف',
    'نينوى',
    'القادسية',
    'صلاح الدين',
    'السليمانية',
    'واسط'
  ];

  var _selectedState = 'بغداد';
  void initState() {
    super.initState();
    checkInternet(context);
    getName().then((updateName));
    getEmail().then((updateEmail));
    getPhone().then((updatePhone));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          title: appBarTitle(getTranslated(context, "complete_order")),
          leading: backArrow(context),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16),
                child: Text(
                  getTranslated(context, "order_detail_product"),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: widget.cartItem
                    .map((index) => Column(
                          children: [
                            ListTile(
                                title: Text(
                                    checkLanguage(
                                        context,
                                        index.product.arabicName,
                                        index.product.enName,
                                        index.product.kuName,
                                        index.product.name),
                                    style: TextStyle(fontSize: SizerUtil.deviceType == DeviceType.tablet
                                        ?16:13,fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  "${double.parse(index.price.toString()).toInt()}  ${getTranslated(context, "short_currency")}",
                                  style: TextStyle(fontSize: SizerUtil.deviceType == DeviceType.tablet
                                      ?13:11),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: IMAGE_URL +
                                        index.product.thumbnailImage,
                                    placeholder: (context, url) =>
                                         loadingSliderHomePage(context,SizerUtil.deviceType == DeviceType.tablet
                                             ?100.0:70.0, SizerUtil.deviceType == DeviceType.tablet
                                             ?100.0:70.0),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.fill,
                                    width:SizerUtil.deviceType == DeviceType.tablet
                                        ?100: 70,
                                    height: SizerUtil.deviceType == DeviceType.tablet
                                        ?100:70,
                                  ),
                                ),
                                trailing: Text(
                                  "${getTranslated(context, "quantity")}:${index.quantity}",
                                  style: TextStyle(fontSize: SizerUtil.deviceType == DeviceType.tablet
                                      ?14:11,),
                                )),
                            SizedBox(height: SizerUtil.deviceType == DeviceType.tablet
                                ?10:0,),
                            SizedBox(
                                width:SizerUtil.deviceType == DeviceType.tablet
                                    ?800: 340,
                                child: Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Colors.grey[200],
                                )),
                            SizedBox(height: SizerUtil.deviceType == DeviceType.tablet
                                ?10:0,),
                          ],
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0, left: 16),
                    child: Text(
                      getTranslated(context, "order_shipping_address"),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: getTranslated(context, "phone_number_hint"),
                              hintStyle: TextStyle(fontSize: 14),
                              contentPadding:
                              EdgeInsets.only(right: 10, left: 10),
                              enabledBorder: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                  new BorderSide(color: Colors.grey[300])),
                              border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                  new BorderSide(color: Colors.grey[300])),
                              focusedBorder: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                  new BorderSide(color: Colors.grey[300])),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return getTranslated(
                                    context, "phone_number_required_filed");
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(right: 10, left: 10),
                              enabledBorder: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.grey[300])),
                              border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.grey[300])),
                              focusedBorder: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.grey[300])),
                              hintText: _selectedState,
                            ),
                           readOnly: true,
                           onTap: ()=>showOptions(context),

                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: addressController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: getTranslated(context, "address_hint"),
                              hintStyle: TextStyle(fontSize: 14),
                              contentPadding:
                                  EdgeInsets.only(right: 10, left: 10),
                              enabledBorder: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.grey[300])),
                              border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.grey[300])),
                              focusedBorder: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                      new BorderSide(color: Colors.grey[300])),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return getTranslated(
                                    context, "address_required_filed");
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: noteController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: getTranslated(context, "note_hint"),
                              hintStyle: TextStyle(fontSize: 14),
                              contentPadding:
                              EdgeInsets.only(right: 10, left: 10),
                              enabledBorder: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                  new BorderSide(color: Colors.grey[300])),
                              border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                  new BorderSide(color: Colors.grey[300])),
                              focusedBorder: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                  borderSide:
                                  new BorderSide(color: Colors.grey[300])),
                            ),
                            maxLines: 6,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 5),
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _selectedState == null
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16.0, left: 16),
                              child: Text(
                                getTranslated(context, "shipping_cost"),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 16.0, left: 16),
                                  child: Text(
                                    "${getTranslated(context, "delivery_cost_in")} $_selectedState ",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16),
                                  child: Text(
                                    "${_selectedState == "بغداد" ? 5000 : 10000} ${getTranslated(context, "short_currency")}",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700],fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey[200],
                              ),
                            ),
                          ],
                        ),
                  _selectedState == null
                      ? SizedBox(
                          height: 0,
                        )
                      : SizedBox(
                          height: 10,
                        ),
                  Container(
                    padding: EdgeInsets.only(right: 16.0, left: 16),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                         getTranslated(context, 'payment_method'),
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              focusColor: Colors.teal[200],
                              value: 0,
                              groupValue: 0,
                            ),
                            new Text(
                              getTranslated(context, 'cash_on_delivery'),
                              style: new TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Radio(
                              value: 1,
                            ),
                            new Text(
                             getTranslated(context, 'zain_cash'),
                              style: new TextStyle(fontSize: 14.0),
                            ),
                            new Text(
                              getTranslated(context, 'coming_soon'),
                              style: new TextStyle(
                                  fontSize: 10.0, color: Colors.red[200]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[200],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 16),
                        child: Text(
                          getTranslated(context, "coupon_title"),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 10),
                            child: SizedBox(
                              child: TextField(
                                controller: couponController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      getTranslated(context, "coupon_hint"),
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width/1.55,
                              height: 40,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/4,
                              height: 35,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                color: Colors.teal[200],
                                elevation: 0,
                                onPressed: () {
                                  checkInternet(context).then((value) async {
                                    if (value == 'ok') {
                                      if(appliedCoupon==false) {
                                        setState(() {
                                          loadingCoupon=true;
                                        });
                                        couponApply(
                                            coupon_code: couponController.text
                                                .trim()
                                                .toString()).then((value) =>   setState(() {
                                          appliedCoupon=true;
                                          loadingCoupon=false;
                                        }));
                                      }
                                      else{
                                        setState(() {
                                          success = false;
                                          discount = 0;
                                          message = '';
                                          appliedCoupon=false;
                                          loadingCoupon=false;
                                        });
                                        couponController.clear();
                                      }
                                    }
                                  });
                                },
                                child: loadingCoupon?SizedBox(width:15,height:15,child: CircularProgressIndicator()):Text(
                                appliedCoupon? getTranslated(context, "delete_from_cart"):  getTranslated(context, "apply"),
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      couponController.text.isNotEmpty
                          ? checkCoupon()
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 16),
                        child: Text(
                          getTranslated(context, "total_price"),
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Text(
                          "${convertToInt(widget.grandTotal)}  ${getTranslated(context, "short_currency")}",
                          style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 16),
                        child: Text(
                          getTranslated(context, "shipping_cost"),
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Text(
                          "$shipping_cost  ${getTranslated(context, "short_currency")}",
                          style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  success == true &&
                          discount != null &&
                          message == "Coupon code applied successfully"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16.0, left: 16),
                              child: Text(
                                getTranslated(context, "discount_amount"),
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700]),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Text(
                                "${convertToInt(((widget.grandTotal+ shipping_cost)*(discount/100)))} ${getTranslated(context, "short_currency")} -",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.red[700],fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 16),
                        child: Text(
                          getTranslated(context, "final_order_price"),
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Text(
                          "${grand_total =convertToInt( success == true && discount != null && message == "Coupon code applied successfully" ?(widget.grandTotal+ shipping_cost) - (( widget.grandTotal+ shipping_cost)*(discount/100))  : widget.grandTotal + shipping_cost)} ${getTranslated(context, "short_currency")}",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.white,
          child: SizedBox(
            height: SizerUtil.deviceType == DeviceType.tablet
                      ?142:117,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: RaisedButton(
                      elevation: 0,
                      color: Colors.teal[300],
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                            checkInternet(context).then((value) async {
                              if (value == 'ok') {
                                SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                                var userId = preferences.getString("userId");
                                setState(() {
                                  isLoading = true;
                                });
                                await widget.bLoC
                                    .addOrder(
                                    user_id: userId,
                                    seller_id: widget.cartItem[0].ownerId,
                                    shipping_address:
                                    '{"name":"${name.toString()
                                        .trim()}","email":"${email.toString()
                                        .trim()}","address":"${addressController
                                        .text.trim()
                                        .toString()}","country":"Iraq","city":"${_selectedState
                                        .toString()
                                        .trim()}","postal_code":"00964","phone":"${phoneController.text.isEmpty?phone:phoneController.text.toString()
                                        .trim()
                                        .toString()}","checkout_type":"logged"}',
                                    coupon_code: couponController.text.trim(),
                                    grand_total:
                                    double.parse(grand_total.toString()),
                                    notes: noteController.text.toString(),
                                    coupon_discount:  success == true &&
                                        discount != null &&
                                        message ==
                                            "Coupon code applied successfully"
                                        ? discount
                                        : "0")
                                    .then((value) {
                                  if (value ==
                                      "Your order has been placed successfully") {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showTopFlash(
                                        context,
                                        '',
                                        getTranslated(
                                            context,
                                            "order_successfully_added"),
                                        false);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ConfirmOrder(
                                                  bLoC: widget.bLoC,
                                                )));
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showTopFlash(
                                        context,
                                        '',
                                        getTranslated(context, "order_error"),
                                        true);
                                  }
                                });
                              }
                            });
                        }
                      },
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator())
                          : Text(
                              getTranslated(context, "order_now"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                    ),
                  ),
                ),
                bottomNavigatorBar(context, 3, widget.bLoC, false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> couponApply({coupon_code}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString("userId");
    var userToken = preferences.getString("access_token");
    String url = MAIN_URL + "coupon/apply";

    Response response = await post(Uri.parse(url),
        body: {"user_id": userId.toString(), "code": coupon_code},  headers: {"Authorization": "Bearer " + userToken});
    Map<String, dynamic> data = json.decode(response.body);
    print(data);
    bool success = data['success'];
    int discount = data['discount'];
    String message = data['message'];
    setState(() {
      this.success = success;
      this.discount = discount;
      this.message = message;
    });
  }

  checkCoupon() {
    if (success == false &&
        discount == null &&
        message == "The coupon is invalid") {
      return Center(
          child: Text(
        getTranslated(context, "invalid_coupon"),
        style: TextStyle(fontSize: 12, color: Colors.red),
      ));
    }
    if (success == false &&
        discount == null &&
        message == "amount of cart less than amount of coupon applied") {
      return Center(
          child: Text(
            getTranslated(context, "amount_coupon"),
            style: TextStyle(fontSize: 12, color: Colors.red),
          ));
    }

    else if (success == true &&
        discount != null &&
        message == "Coupon code applied successfully") {
      return Center(
          child: Text(
        "${getTranslated(context, "coupon_apply_successfully")} $discount%",
        style: TextStyle(fontSize: 12, color: Colors.green),
      ));
    } else if (success == false &&
        message == "The coupon is already applied. Please try another coupon") {
      return Center(
          child: Text(
        getTranslated(context, "coupon_already_used"),
        style: TextStyle(fontSize: 12, color: Colors.red),
      ));
    } else {
      return Container();
    }
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
  updatePhone(String phone) {
    setState(() {
      this.phone = phone;
    });
  }

  convertToInt(number){
   return number.toInt();
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
                  child:  StreamBuilder<UnmodifiableListView<States>>(
    stream: widget.bLoC.allStates,
    initialData: UnmodifiableListView<States>([]),
    builder: (context, snap) {
      return snap.hasData && snap.data.isNotEmpty
          ?  Column(
          children: snap.data.map((e) =>
              ListTile(
                  onTap: () {
                    setState(() {
                      _selectedState = checkLanguage(context, e.arName, e.enName, e.kuName, e.name);
                      shipping_cost=e.cost;
                    });
                    Navigator.pop(context);
                  },
                  title: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: _selectedState == checkLanguage(context, e.arName, e.enName, e.kuName, e.name) ? Theme
                            .of(context)
                            .primaryColor : Colors.grey[300],
                            width: _selectedState == checkLanguage(context, e.arName, e.enName, e.kuName, e.name) ? 1.5 : 1)),
                    child: Row(
                      children: [
                        Text(
                          checkLanguage(context, e.arName, e.enName, e.kuName, e.name),
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
              ),
          ).toList()
      )
          : Column(
          children: states.map((e) =>
              ListTile(
                  onTap: () {
                    setState(() {
                      _selectedState = e;
                    });
                    Navigator.pop(context);
                  },
                  title: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: _selectedState == e ? Theme
                            .of(context)
                            .primaryColor : Colors.grey[300],
                            width: _selectedState == e ? 1.5 : 1)),
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
      );
    }
                  ),
                ),
              ),
            ],
          );
        });
  }
}
