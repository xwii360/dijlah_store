import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/order_detail.dart';
import 'package:dijlah_store_ibtechiq/model/order_history.dart';
import 'package:dijlah_store_ibtechiq/screens/add_review.dart';
import 'package:dijlah_store_ibtechiq/service/refund_api.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:dijlah_store_ibtechiq/widget/timeline_order_status.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class OrderDetails extends StatefulWidget {
  final BLoC bLoC;
  final AllOrderHistory orderDetail;
  final isRefund;
  const OrderDetails({Key key, this.bLoC, this.orderDetail, this.isRefund})
      : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isLoading = true;
  bool isLoadingRefund = false;
  var _steps = [
    'pending',
    'cancelled',
    'confirmed',
    'on_delivery',
    'delivered'
  ];
  int _stepIndex = 0;
  final _formKey = new GlobalKey<FormState>();
  TextEditingController reasonController = TextEditingController();
  bool isRefund = false;

  bool isLoadingCancelled = false;

  bool isRefundabled=false;
  @override
  void initState() {
    checkInternet(context).then((value) async {
      if (value == 'ok') {
        checkIsOrderRefunded(widget.orderDetail.id).then((value) =>   setState(()=>isRefund=value));
        widget.bLoC.getOrderDetailFuture(widget.orderDetail.id).then((value) {
          setState(() {
            isLoading = false;
          });
          setStepIndex(value[0].deliveryStatus);
        });
      }
    });
    super.initState();
  }

  setStepIndex(key) {
    _stepIndex = _steps.indexOf(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          title: appBarTitle(getTranslated(context, "order_detail")),
          leading: backArrow(context),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.grey[50]),
                  child: Column(
                    children: [
                      Text(
                        "${getTranslated(context, "order_number_in_detail")} ${widget.orderDetail.code}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${getTranslated(context, "order_date")} ${widget.orderDetail.date}",
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.grey[200]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, "summary_order"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context, "sub_total_price")}",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[800]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${double.parse(widget.orderDetail.subtotal.toString()).toInt()} ${getTranslated(context, "short_currency")} ",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700],fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context, "shipping_cost")}",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[800]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${double.parse(widget.orderDetail.shippingCost.toString()).toInt().toString()} ${getTranslated(context, "short_currency")} ",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700],fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context, "payment_type")}",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[800]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.orderDetail.paymentType == "cash on delivery"
                                ? getTranslated(context, 'cash_on_delivery')
                                : getTranslated(context, 'another_payment'),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700],fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${getTranslated(context, "total_price_in_detail")}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                        double.parse( widget.orderDetail.grandTotal.toString()).toInt().toString()
                            +
                                " ${getTranslated(context, "short_currency")} ",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.grey[100]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, "shipping_address_detail"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.orderDetail.shippingAddress.name,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.orderDetail.shippingAddress.email,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.orderDetail.shippingAddress.phone,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.orderDetail.shippingAddress.country,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.orderDetail.shippingAddress.address,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.grey[100]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, "note"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.orderDetail.notes,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(14),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.grey[200]),
                child: Text(
                  getTranslated(context, "order_detail_product"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey[700]),
                ),
              ),
              widget.isRefund == true
                  ? Container()
                  : SizedBox(
                      height: 10,
                    ),
              widget.isRefund == true ? Container() : TimeLineOrderStatus(stepIndex: _stepIndex,),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<UnmodifiableListView<OrderDetail>>(
                  stream: widget.bLoC.allOrderDetail,
                  initialData: UnmodifiableListView<OrderDetail>([]),
                  builder: (context, snap) {
                    if (snap.data.length > 0 && snap.data.isNotEmpty) {
                      return Column(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: snap.data
                                  .map((e) => Card(
                                        elevation: 1,
                                        margin: EdgeInsets.all(0.2),
                                        shadowColor: Colors.grey[100],
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  imageUrl: IMAGE_URL +
                                                      e.productThumbnailImage,
                                                  placeholder: (context, url) =>
                                                      loadingSliderHomePage(
                                                          context,
                                                          SizerUtil.deviceType ==
                                                              DeviceType.tablet
                                                              ? 20.w
                                                              : 20.w,
                                                          SizerUtil.deviceType ==
                                                              DeviceType.tablet
                                                              ? 20.w
                                                              : 20.w),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  width: 100,
                                                  height: 120,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: SizerUtil
                                                                  .deviceType ==
                                                              DeviceType.tablet
                                                          ? 70.w
                                                          : 60.w,
                                                      child: Text(
                                                        checkLanguage(
                                                            context,
                                                            e.arName,
                                                            e.enName,
                                                            e.kuName,
                                                            e.name),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey[800]),
                                                      )),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${getTranslated(context, "price_order")}: ${double.parse( e.price.toString()).toInt()} ${getTranslated(context, "short_currency")}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[800]),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        "${getTranslated(context, "quantity")}: " +
                                                            e.quantity
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[800]),
                                                      ),
                                                    ],
                                                  ),
                                                  e.variation == ''
                                                      ? Container()
                                                      : SizedBox(height: 10),
                                                  e.variation == ''
                                                      ? Container()
                                                      : Text(
                                                          "  ${getTranslated(context, "size_color")}: " +
                                                              e.variation,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[800]),
                                                        ),
                                                  SizedBox(
                                                    height: e.deliveryStatus ==
                                                            'delivered'
                                                        ? 5
                                                        : 0,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      widget.isRefund != true &&
                                                              e.deliveryStatus ==
                                                                  'delivered'
                                                          ? TextButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                AddReview(
                                                                                  title: checkLanguage(context, e.arName, e.enName, e.kuName, e.name),
                                                                                  productId: e.productId,
                                                                                  bLoC: widget.bLoC,
                                                                                )));
                                                              },
                                                              child: Text(
                                                                getTranslated(context, 'review_product'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .teal[500]),
                                                              ))
                                                          : Container(),
                                                   SizedBox(width: 20,),
                                                   e.refundable==true&& widget.isRefund != true &&
                                                          isRefund == false &&
                                                          snap.data[0].deliveryStatus == "delivered"
                                                          ? Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: SizedBox(
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  checkInternet(context)
                                                                      .then((value) async {
                                                                    if (value == 'ok') {
                                                                          refundDialog();
                                                                    }
                                                                  });
                                                                },
                                                                child: Text(getTranslated(context, 'refund_order'),style: TextStyle(color: Colors.red[300]),))),
                                                      )
                                                          : Container(),
                                                    ],
                                                  ),
                                                  snap.data.length > 0
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  right: 0),
                                                          child: Divider(
                                                            height: 0,
                                                            thickness: 1,
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList()),
                          SizedBox(
                            height: 10,
                          ),
                          widget.isRefund != true &&
                                  snap.data[0].deliveryStatus == "pending"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 45,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              primary: Colors.orange[400]),
                                          onPressed: () async {
                                            checkInternet(context)
                                                .then((value) async {
                                              if (value == 'ok') {
                                                setState(() {
                                                  isLoadingCancelled = true;
                                                });
                                                await cancelledRequest(widget.orderDetail.id)
                                                    .then((value) {
                                                  setState(() {
                                                    isLoadingCancelled = false;
                                                  });
                                                  widget.bLoC
                                                      .getOrderDetailFuture(
                                                          widget.orderDetail.id)
                                                      .then((value) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    setStepIndex(value[0]
                                                        .deliveryStatus);
                                                  });
                                                });
                                              }
                                            });
                                          },
                                          child: isLoadingCancelled
                                              ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator())
                                              : Text(getTranslated(context, 'cancel_order')))),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }
                    return !isLoading
                        ? Padding(
                            padding: const EdgeInsets.only(top: 58.0),
                            child: Center(
                              child: Text(getTranslated(context, 'no_data')),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 58.0),
                            child: Center(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator())),
                          );
                  }),
            ],
          ),
        ),
        bottomNavigationBar:
            bottomNavigatorBar(context, 4, widget.bLoC, false));
  }
  Future checkIsProductIsRefundable(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString("access_token");
    if((userToken!=null) ) {
      String url = MAIN_URL + "product-refund/$id";
      Response response = await get(
          Uri.parse(url),
          headers: {"Authorization": "Bearer " + userToken}
      );
      print(response.body);
      var data = jsonDecode(response.body);
         return data['status'];
    }
  }
  refundDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: SizedBox(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                      getTranslated(context, 'refund_reason'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: reasonController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return getTranslated(
                                context, "full_name_required_filed");
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        maxLines: 6,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                   getTranslated(context, 'cancel'),
                    style: TextStyle(
                      fontFamily: "sans",
                    ),
                  ),
                  onPressed: () {
                    reasonController.clear();
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: isLoadingRefund
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                      : Text(
                         getTranslated(context, 'send'),
                          style: TextStyle(
                            fontFamily: "sans",
                          ),
                        ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      checkInternet(context).then((value) async {
                        if (value == 'ok') {
                          setState(() {
                            isLoadingRefund = true;
                          });
                          refundRequest(widget.orderDetail.id,reasonController.text).then((value) async {
                            setState(() {
                              isLoadingRefund = false;
                            });
                            if (value ==
                                "Refund Request has been sent successfully") {
                            await  checkIsOrderRefunded(widget.orderDetail.id).then((value) =>   setState(()=>isRefund=value));
                              setState(() {});
                              Navigator.of(context).pop();
                            setState(() {});
                              return showTopFlash(
                                  context, "", getTranslated(context, 'request_send_successfully'), false);
                            } else {
                              setState(() {});
                              return showTopFlash(
                                  context,
                                  "",
                                  getTranslated(context, "call_us_error"),
                                  false);
                            }
                          });
                        }
                      });
                    }
                  },
                ),
              ],
            ));
  }



}