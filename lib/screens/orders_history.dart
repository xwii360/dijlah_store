import 'dart:collection';
import 'dart:ui';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/order_history.dart';
import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:dijlah_store_ibtechiq/screens/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class OrdersHistory extends StatefulWidget {
  final BLoC bLoC;
 final fromOrder;
  const OrdersHistory({Key key, this.bLoC, this.fromOrder}) : super(key: key);
  @override
  _OrdersHistoryState createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  bool isLoading=true;
  @override
  void initState() {
    checkInternet(context);
    widget.bLoC.getAllOrderHistoryFuture().then((value) =>  setState(() {
      isLoading=false;
    }));
    super.initState();
  }

  getBack(){
    if(widget.fromOrder==true) {
      return  Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomeScreen(bLoC: widget.bLoC,)));
    }
    else {
      return  Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()=>refreshData(),
      child: WillPopScope(
        onWillPop:()=>getBack(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
            title:appBarTitle(getTranslated(context, "order_history_title")),
            centerTitle: false,
            leading: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.grey[800],
                ),
                onPressed: () {
                  getBack();
                },
              ),
            ),
          ),
          body: Align(
            alignment: Alignment.topRight,
            child: StreamBuilder<UnmodifiableListView<AllOrderHistory>>(
                stream: widget.bLoC.allOrderHistory,
                initialData: UnmodifiableListView<AllOrderHistory>([]),
                builder: (context, snap) {
                  if(snap.hasData && snap.data.length>0) {
                    return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: snap.data
                                        .map((e) =>
                                        GestureDetector(
                                          onTap: () {
                                           Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
                                                        OrderDetails(
                                                          bLoC: widget.bLoC,
                                                          orderDetail: e,
                                                        )));
                                          },
                                          child: Column(
                                            children: [
                                              Card(
                                                elevation: 0,
                                                shadowColor: Colors.grey[100],
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      13.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${getTranslated(
                                                                context,
                                                                "order_number")}:",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color:
                                                                Colors
                                                                    .grey[800]),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            e.code,
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                Colors
                                                                    .grey[700]),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${getTranslated(
                                                                context,
                                                                "payment_type")}:",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color:
                                                                Colors
                                                                    .grey[800]),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            e.paymentType ==
                                                                "cash on delivery"
                                                                ? getTranslated(
                                                                context,
                                                                "paymentType_cod")
                                                                : getTranslated(
                                                                context,
                                                                "paymentType_other"),
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                Colors
                                                                    .grey[700]),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${getTranslated(
                                                                context,
                                                                "payment_status_title")}:",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color:
                                                                Colors
                                                                    .grey[800]),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            e.paymentStatus ==
                                                                "paid"
                                                                ? getTranslated(
                                                                context,
                                                                "paymentStatus_paid")
                                                                : getTranslated(
                                                                context,
                                                                "paymentStatus_unpaid"),
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                e
                                                                    .paymentStatus ==
                                                                    "paid"
                                                                    ? Colors
                                                                    .green[
                                                                400]
                                                                    : Colors
                                                                    .red[
                                                                400]),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${getTranslated(
                                                                context,
                                                                "total_price")}:",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color:
                                                                Colors
                                                                    .grey[800]),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                              double.parse(e.grandTotal.toString()).toInt().toString()
                                                                .toString() +
                                                                " ${getTranslated(
                                                                    context,
                                                                    "short_currency")} ",
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                Colors
                                                                    .grey[700]),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "${getTranslated(
                                                                context,
                                                                "shipping_address")}:",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color:
                                                                Colors
                                                                    .grey[800]),
                                                          ),

                                                          SizedBox(
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width / 2.0,
                                                              child: Text(
                                                                e
                                                                    .shippingAddress
                                                                    .address +
                                                                    " / " +
                                                                    e
                                                                        .shippingAddress
                                                                        .country +
                                                                    " / " +
                                                                    e
                                                                        .shippingAddress
                                                                        .phone,
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color:
                                                                    Colors
                                                                        .grey[700]),
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              snap.data.length > 0
                                                  ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0, right: 0),
                                                child: Divider(
                                                  height: 0,
                                                  thickness: 1,
                                                  color: Colors.grey[200],
                                                ),
                                              )
                                                  : Container()
                                            ],
                                          ),
                                        ))
                                        .toList()),
                              ],
                            ),
                          ],
                        ));
                  }
                  return isLoading?Center(child: CircularProgressIndicator(),):Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 160),
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_basket_rounded,
                              size: 130,
                              color: color1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              getTranslated(context, "empty_order_history_title"),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                getTranslated(
                                    context, "empty_order_history_description"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );


                }),
          ),
          bottomNavigationBar: bottomNavigatorBar(context, 4, widget.bLoC, false),
        ),
      ),
    );
  }
  Future<String> refreshData() async {
    await widget.bLoC.getAllOrderHistoryFuture();
    return 'success';
  }
}
