import 'dart:collection';
import 'dart:ui';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/refund_history.dart';
import 'package:dijlah_store_ibtechiq/screens/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RefundHistory extends StatefulWidget {
  final BLoC bLoC;
  const RefundHistory({Key key, this.bLoC}) : super(key: key);
  @override
  _RefundHistoryState createState() => _RefundHistoryState();
}

class _RefundHistoryState extends State<RefundHistory> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  bool isLoading=true;
  @override
  void initState() {
    checkInternet(context);
    widget.bLoC.getRefundHistoryFuture().then((value) =>  setState(() {
      isLoading=false;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()=>refreshData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          title: appBarTitle(getTranslated(context, "refund_history")),
          leading: backArrow(context),
        ),
        body: Align(
          alignment: Alignment.topRight,
          child: StreamBuilder<UnmodifiableListView<AllRefundHistory>>(
              stream: widget.bLoC.allRefundHistory,
              initialData: UnmodifiableListView<AllRefundHistory>([]),
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
                                            orderDetail: e.orderDetail[0],
                                            isRefund: true,
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
                                                          e.orderDetail[0].code,
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
                                                          e.orderDetail[0].paymentType ==
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
                                                          e.refundStatus ==
                                                              0
                                                              ? getTranslated(context, 'on_review')
                                                              : getTranslated(context, 'reject_request'),
                                                          textAlign: TextAlign.end,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                              e.orderDetail[0].paymentStatus ==
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
                                                  e.refundStatus==1?  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                         getTranslated(context, 'reject_reason'),
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
                                                        SizedBox(
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width / 2.0,
                                                          child: Text(
                                                            e.rejectReason==''?getTranslated(context, "no_reason"): e.rejectReason,
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                e.orderDetail[0].paymentStatus ==
                                                                    "paid"
                                                                    ? Colors
                                                                    .green[
                                                                400]
                                                                    : Colors
                                                                    .red[
                                                                400]),
                                                          ),
                                                        ),
                                                      ],
                                                    ):Container(),
                                                    SizedBox(
                                                      height:    e.refundStatus==1?10:0,
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
                                                            double.parse( e.refundAmount.toString()).toInt().toString()

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
    );
  }
  Future<String> refreshData() async {
    await widget.bLoC.getAllOrderHistoryFuture();
    return 'success';
  }
}
