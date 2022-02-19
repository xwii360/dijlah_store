import 'dart:async';
import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/model/color.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/cartItem.dart';
import 'package:dijlah_store_ibtechiq/screens/checkout.dart';
import 'package:dijlah_store_ibtechiq/screens/detail_product.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:dijlah_store_ibtechiq/widget/product_list.dart';
import 'package:dijlah_store_ibtechiq/widget/wishlist_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class Cart extends StatefulWidget {
  final BLoC bLoC;

  const Cart({Key key, this.bLoC}) : super(key: key);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<String> goToCheckout = [];
  List<ColorsModel> colorsList=[];
  bool loadingColor=true;
  @override
  void initState() {
    checkInternet(context);
    widget.bLoC.getColors().then((value) {
      setState(() {
        loadingColor=false;
        colorsList=value;
      });
    });
    super.initState();
  }
getColor(color){
    print(color);
    for(int i=0;i<colorsList.length;i++){
      if(colorsList[i].name==color){
        return colorsList[i].code;
      }
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: appBarTitle(getTranslated(context, "cart")),
        titleSpacing: 0.0,
        leading: backArrow(context),
            centerTitle: false,
          ),
      body: StreamBuilder<List<CartItem>>(
        stream: widget.bLoC.cartItems,
        initialData: UnmodifiableListView<CartItem>([]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0 || snapshot.data.isEmpty)
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        size: SizerUtil.deviceType == DeviceType.tablet
                            ? 155
                            : 90,
                        color: color1,
                      ),
                      Text(
                        getTranslated(context, "empty_cart_title"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 8.sp
                                : 16.sp),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        getTranslated(context, "empty_cart_description"),
                        style: TextStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 6.sp
                                : 12.sp),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ProductMyLike(bLoC: widget.bLoC,title: getTranslated(context, "may_you_like_products"),)
                    ],
                  ),
                ),
              );
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: snapshot.data
                        .map((index) => Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10, bottom: 2),
                                  child: GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: DetailProduct(
                                                product: index.product,
                                                bLoC: widget.bLoC,
                                              )));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: SizerUtil.deviceType ==
                                                      DeviceType.tablet
                                                  ? 70.w
                                                  : 65.w,
                                              child: Text(
                                                checkLanguage(
                                                    context,
                                                    index.product.arabicName,
                                                    index.product.enName,
                                                    index.product.kuName,
                                                    index.product.name),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      SizerUtil.deviceType ==
                                                              DeviceType.tablet
                                                          ? 7.sp
                                                          : 12.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: index.variation == ''
                                                  ? 0
                                                  : 10,
                                            ),
                                            index.variation == ''
                                                ? Container()
                                                : Column(
                                                    children: [
                                                      Text(
                                                        getTranslated(context,
                                                            "product_variation"),
                                                        style: TextStyle(
                                                          fontSize: SizerUtil
                                                                      .deviceType ==
                                                                  DeviceType
                                                                      .tablet
                                                              ? 6.sp
                                                              : 11.sp,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                           getTranslated(context, 'size'),
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            index.variation
                                                                    .contains(
                                                                        "-")
                                                                ? index
                                                                    .variation
                                                                    .split(
                                                                        "-")[1]
                                                                : index
                                                                    .variation,
                                                            style: TextStyle(
                                                              fontSize: SizerUtil
                                                                          .deviceType ==
                                                                      DeviceType
                                                                          .tablet
                                                                  ? 6.sp
                                                                  : 11.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (index.variation
                                                          .contains('-'))
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                      if (index.variation
                                                          .contains('-'))
                                                        Row(
                                                          children: [
                                                            Text(
                                                            getTranslated(context, 'color'),
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                           if(loadingColor==false) Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color(int.parse(getColor(
                                                                        index.variation.split("-")[
                                                                            0])
                                                                    .replaceFirst(
                                                                        "#",
                                                                        '0xff'))),
                                                              ),
                                                              width: 15,
                                                              height: 15,
                                                            ),
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${double.parse(index.price.toString()).toInt()}" +
                                                  " " +
                                                  getTranslated(context,
                                                      "short_currency"),
                                              style: TextStyle(
                                                  fontSize:
                                                      SizerUtil.deviceType ==
                                                              DeviceType.tablet
                                                          ? 6.sp
                                                          : 11.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700]),
                                            ),
                                            checkCart(index),
                                          ],
                                        ),
                                        CachedNetworkImage(
                                          imageUrl: IMAGE_URL +
                                              index.product.thumbnailImage,
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
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.contain,
                                          height: SizerUtil.deviceType ==
                                                  DeviceType.tablet
                                              ? 20.w
                                              : 20.w,
                                          width: SizerUtil.deviceType ==
                                                  DeviceType.tablet
                                              ? 20.w
                                              : 20.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 5, left: 5),
                                      child: Container(
                                        height: SizerUtil.deviceType ==
                                                DeviceType.tablet
                                            ? 3.5.h
                                            : 3.5.h,
                                        width: SizerUtil.deviceType ==
                                                DeviceType.tablet
                                            ? 21.w
                                            : 32.w,
                                        color: Colors.grey[50],
                                        child: changeQuantityCartAlert(
                                            context, index),
                                      ),
                                    ),
                                    WishListButton(
                                      bLoC: widget.bLoC,
                                      productId: index.product.id,
                                      fromCart: true,
                                      productName: checkLanguage(
                                          context,
                                          index.product.arabicName,
                                          index.product.enName,
                                          index.product.kuName,
                                          index.product.name),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, left: 16, right: 16),
                                        child: InkWell(
                                          onTap: () {
                                            checkInternet(context)
                                                .then((value) async {
                                              if (value == 'ok') {
                                                deleteCartAlert(context, index);
                                              }
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              index.isLoadingDelete ?? false
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: SizedBox(
                                                          width: 10,
                                                          height: 10,
                                                          child: CircularProgressIndicator(
                                                              backgroundColor:
                                                                  Colors
                                                                      .white)),
                                                    )
                                                  : SizedBox(
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .delete_outline_rounded,
                                                          color:
                                                              Colors.red[300],
                                                        ),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        color: Colors.grey[700],
                                                        iconSize: SizerUtil
                                                                    .deviceType ==
                                                                DeviceType
                                                                    .tablet
                                                            ? 32
                                                            : 22,
                                                      ),
                                                      width: SizerUtil
                                                                  .deviceType ==
                                                              DeviceType.tablet
                                                          ? 35
                                                          : 25,
                                                    ),
                                              Text(
                                                getTranslated(context,
                                                    "delete_from_cart"),
                                                style: TextStyle(
                                                    color: Colors.red[300],
                                                    fontSize: SizerUtil
                                                                .deviceType ==
                                                            DeviceType.tablet
                                                        ? 6.sp
                                                        : 11.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 0,
                                      right: 0,
                                      top: SizerUtil.deviceType ==
                                              DeviceType.tablet
                                          ? 15
                                          : 20,
                                      bottom: 20),
                                  child: Divider(
                                    height: 0,
                                    thickness: 1,
                                    color: Colors.grey[200],
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ProductMyLike(bLoC: widget.bLoC,title: getTranslated(context, "may_you_like_products"),)
                ],
              ),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.white,
          child: StreamBuilder<List<CartItem>>(
              stream: widget.bLoC.cartItems,
              initialData: UnmodifiableListView<CartItem>([]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  getTotalPrice(snapshot);
                  getTotalQuantity(snapshot);
                  if (snapshot.data.length != 0 || snapshot.data.isNotEmpty)
                    return SizedBox(
                      height: SizerUtil.deviceType == DeviceType.tablet
                          ?132:117,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                color: Colors.teal[300],
                                elevation: 0,
                                child: Text(
                                  " ${getTranslated(context, "buy")} ${getTotalQuantity(snapshot).toString()} ${getTranslated(context, "price")} ${getTotalPrice(snapshot)} ${getTranslated(context, "short_currency")} ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                ),
                                onPressed: () {
                                  checkInternet(context).then((value) async {
                                    if (value == 'ok') {
                                      setState(() {});
                                      goToCheckout.contains("false") ||
                                              goToCheckout.isEmpty
                                          ? showTopFlash(
                                              context,
                                              getTranslated(context, 'before_checkout1'),
                                              getTranslated(context, 'before_checkout2'),
                                              true)
                                          : Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: CheckOut(
                                                    bLoC: widget.bLoC,
                                                    cartItem: snapshot.data,
                                                    grandTotal:
                                                        getTotalPrice(snapshot),
                                                  )));
                                      goToCheckout.clear();
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          bottomNavigatorBar(context, 3, widget.bLoC, false),
                        ],
                      ),
                    );
                  return bottomNavigatorBar(context, 3, widget.bLoC, false);
                }
                return Container(
                  height: 0,
                );
              })),
    );
  }

  getTotalPrice(snapshot) {
    var total = snapshot.data;
    var sum = 0.0;
    total.forEach((element) {
      var x = 0.0;
      x += element.price * element.quantity;
      sum += x;
    });
    return  double.parse(sum.toString()).toInt();
  }

  getTotalQuantity(snapshot) {
    var total = snapshot.data;
    var sum = 0;
    total.forEach((element) {
      var x = 0;
      x += element.quantity;
      sum += x;
    });
    return sum;
  }

  checkCart(e) {
    return FutureBuilder(
      future: widget.bLoC.checkCart(quantity: e.quantity, cardId: e.id),
      builder: (context, snapshot) {
        checkInternet(context).then((value) async {
          if (value == 'ok') {
            goToCheckout.clear();
            if (snapshot.hasData) {
              var value = snapshot.data;
              if (value.contains('item(s) are available for')) {
                goToCheckout.add("false");
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                  child: Text(
                    " ${getTranslated(context, 'available_quantity')} ${value.substring(4, 7)} ",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontFamily: 'sans',
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else if (value.contains(',remove this from cart')) {
                goToCheckout.add("false");
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                  child: Text(
                   getTranslated(context, 'sold_out'),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontFamily: 'sans',
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else if (value == 'Cart updated') {
                goToCheckout.add("true");
              }
            }
          }
        });
        return Container();
      },
    );
  }

  changeQuantityCartAlert(context, index) {
    return StatefulBuilder(builder: (context, setState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.plus,
              size: SizerUtil.deviceType == DeviceType.tablet ? 15 : 10,
            ),
            onPressed: () async {
              checkInternet(context).then((value) async {
                if (value == 'ok') {
                  setState(() {
                    index.isLoadingQuantity = true;
                  });
                  await widget.bLoC
                      .updateQuantity(
                          product_id: index.id,
                          type: 'plus',
                          product_quantity: index.quantity + 1)
                      .then((value) {
                    print(value);
                    if (value == "Maximum available quantity reached") {
                      setState(() {
                        index.isLoadingQuantity = false;
                      });
                      showTopFlash(
                          context,
                          checkLanguage(
                              context,
                              index.product.arabicName,
                              index.product.enName,
                              index.product.kuName,
                              index.product.name),
                          getTranslated(context, "Maximum_available_quantity"),
                          true);
                    } else if (value == "Cart updated") {
                      setState(() {
                        index.isLoadingQuantity = false;
                      });
                      showTopFlash(
                          context,
                          checkLanguage(
                              context,
                              index.product.arabicName,
                              index.product.enName,
                              index.product.kuName,
                              index.product.name),
                          getTranslated(context, "Cart_updated"),
                          false);
                    } else {
                      setState(() {
                        index.isLoadingQuantity = false;
                      });
                      showTopFlash(
                          context,
                          checkLanguage(
                              context,
                              index.product.arabicName,
                              index.product.enName,
                              index.product.kuName,
                              index.product.name),
                          getTranslated(context, "error_update_user_info"),
                          true);
                    }
                  });
                }
              });
            },
          ),
          index.isLoadingQuantity ?? false
              ? SizedBox(
                  width: 10,
                  height: 10,
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white))
              : Text(
                  index.quantity.toString(),
                  style: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 7.sp
                          : 11.sp,
                      fontFamily: 'sans'),
                ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.minus,
              size: SizerUtil.deviceType == DeviceType.tablet ? 15 : 10,
            ),
            onPressed: () {
              checkInternet(context).then((value) async {
                if (value == 'ok') {
                  if (index.quantity <= 1) {
                    deleteCartAlert(context, index);
                  } else {
                    setState(() {
                      index.isLoadingQuantity = true;
                    });
                    widget.bLoC
                        .updateQuantity(
                            product_id: index.id,
                            type: 'minus',
                            product_quantity: index.quantity - 1)
                        .then((value) {
                      setState(() {
                        index.isLoadingQuantity = false;
                      });
                      if (value == "Maximum available quantity reached") {
                        showTopFlash(
                            context,
                            checkLanguage(
                                context,
                                index.product.arabicName,
                                index.product.enName,
                                index.product.kuName,
                                index.product.name),
                            getTranslated(
                                context, "Maximum_available_quantity"),
                            true);
                      } else if (value == "Cart updated") {
                        setState(() {
                          index.isLoadingQuantity = false;
                        });
                        showTopFlash(
                            context,
                            checkLanguage(
                                context,
                                index.product.arabicName,
                                index.product.enName,
                                index.product.kuName,
                                index.product.name),
                            getTranslated(context, "Cart_updated"),
                            false);
                      } else {
                        setState(() {
                          index.isLoadingQuantity = false;
                        });
                        showTopFlash(
                            context,
                            checkLanguage(
                                context,
                                index.product.arabicName,
                                index.product.enName,
                                index.product.kuName,
                                index.product.name),
                            getTranslated(context, "error_update_user_info"),
                            true);
                      }
                    });
                    setState(() {});
                  }
                }
              });
            },
          ),
        ],
      );
    });
  }

  Future<bool> deleteCartAlert(context, index) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                getTranslated(context, "delete_cart"),
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "sans",
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    getTranslated(context, "no"),
                    style: TextStyle(
                      fontFamily: "sans",
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    getTranslated(context, "yes"),
                    style: TextStyle(
                      fontFamily: "sans",
                    ),
                  ),
                  onPressed: () {
                    checkInternet(context).then((value) async {
                      if (value == 'ok') {
                        Navigator.of(context).pop();
                        setState(() {
                          index.isLoadingDelete = true;
                        });
                        widget.bLoC
                            .deleteFromCart(product_id: index.id)
                            .then((value) {
                          if (value ==
                              "Product is successfully removed from your cart") {
                            setState(() {
                              index.isLoadingDelete = false;
                            });
                          } else {
                            setState(() {
                              index.isLoadingDelete = false;
                            });
                          }
                        });
                      }
                    });
                  },
                ),
              ],
            ));
  }
}
