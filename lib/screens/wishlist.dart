import 'dart:async';
import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/wishList.dart';
import 'package:dijlah_store_ibtechiq/screens/detail_product.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:dijlah_store_ibtechiq/widget/product_list.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class WishList extends StatefulWidget {
  final BLoC bLoC;

  const WishList({Key key, this.bLoC}) : super(key: key);
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  Timer timer;
  bool _visibleList = true;

  @override
  void initState() {
    checkInternet(context);
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (this.mounted) {
        setState(() {
          _visibleList = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refreshData(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: appBarTitle(getTranslated(context, "wish_list")),
            leading: backArrow(context),
            centerTitle: false,
          ),
          body: StreamBuilder<List<WishLists>>(
            stream: widget.bLoC.allWishList,
            initialData: UnmodifiableListView<WishLists>([]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0 || snapshot.data.isEmpty)
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_outline_rounded,
                            size: SizerUtil.deviceType == DeviceType.tablet
                                ? 155
                                : 90,
                            color: color1,
                          ),
                          Text(
                            getTranslated(context, "empty_wish_list_title"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 8.sp
                                        : 16.sp),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            getTranslated(
                                context, "empty_wish_list_description"),
                            style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
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
                return snapshot.data.isNotEmpty && snapshot.hasData
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: snapshot.data
                                  .map((index) => GestureDetector(
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
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10,
                                                  bottom: 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: SizerUtil
                                                                    .deviceType ==
                                                                DeviceType
                                                                    .tablet
                                                            ? 70.w
                                                            : 65.w,
                                                        child: Text(
                                                          checkLanguage(
                                                              context,
                                                              index.product
                                                                  .arabicName,
                                                              index.product
                                                                  .enName,
                                                              index.product
                                                                  .kuName,
                                                              index.product
                                                                  .name),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: SizerUtil
                                                                        .deviceType ==
                                                                    DeviceType
                                                                        .tablet
                                                                ? 7.sp
                                                                : 12.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${index.product.basePrice.toString()} ${getTranslated(context, "short_currency")} ",
                                                        style: TextStyle(
                                                            fontSize: SizerUtil
                                                                        .deviceType ==
                                                                    DeviceType
                                                                        .tablet
                                                                ? 6.sp
                                                                : 11.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                    ],
                                                  ),
                                                  CachedNetworkImage(
                                                    imageUrl: IMAGE_URL +
                                                        index.product
                                                            .thumbnailImage,
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                            loadingSliderHomePage(
                                                                context,
                                                                SizerUtil.deviceType ==
                                                                    DeviceType.tablet
                                                                    ? 20.w
                                                                    : 20.w,
                                                                SizerUtil.deviceType ==
                                                                    DeviceType.tablet
                                                                    ? 20.w
                                                                    : 20.w)),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    fit: BoxFit.contain,
                                                    height: SizerUtil
                                                                .deviceType ==
                                                            DeviceType.tablet
                                                        ? 20.w
                                                        : 20.w,
                                                    width: SizerUtil
                                                                .deviceType ==
                                                            DeviceType.tablet
                                                        ? 20.w
                                                        : 20.w,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0.0,
                                                            left: 16,
                                                            right: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        index.isLoadingDelete ??
                                                                false
                                                            ? SizedBox(
                                                                width: 10,
                                                                height: 10,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                ))
                                                            : SizedBox(
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(Icons
                                                                      .delete_outline_rounded),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  iconSize: SizerUtil
                                                                              .deviceType ==
                                                                          DeviceType
                                                                              .tablet
                                                                      ? 32
                                                                      : 22,
                                                                  onPressed:
                                                                      () {
                                                                    checkInternet(
                                                                            context)
                                                                        .then(
                                                                            (value) async {
                                                                      if (value ==
                                                                          'ok') {
                                                                        deleteWishListAlert(
                                                                            context,
                                                                            index);
                                                                      }
                                                                    });
                                                                  },
                                                                ),
                                                                width: SizerUtil
                                                                            .deviceType ==
                                                                        DeviceType
                                                                            .tablet
                                                                    ? 35
                                                                    : 25,
                                                              ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          getTranslated(context,
                                                              "delete_from_cart"),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[500],
                                                              fontSize: SizerUtil
                                                                          .deviceType ==
                                                                      DeviceType
                                                                          .tablet
                                                                  ? 6.sp
                                                                  : 11.sp),
                                                        )
                                                      ],
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
                                                      : 2),
                                              child: Divider(
                                                height: 0,
                                                thickness: 1,
                                                color: Colors.grey[200],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ProductMyLike(bLoC: widget.bLoC,title: getTranslated(context, "may_you_like_products"),)
                          ],
                        ),
                      )
                    : Visibility(
                        visible: snapshot.data.isNotEmpty
                            ? false
                            : snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? true
                                : _visibleList,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                                5, (index) => loadingCart(context)),
                          ),
                        ),
                      );
              }
              return Container();
            },
          ),
          bottomNavigationBar:
              bottomNavigatorBar(context, 4, widget.bLoC, false)),
    );
  }
  Future<String> refreshData() async {
    await widget.bLoC.getAllWishListFuture();
    return 'success';
  }

  Future<bool> deleteWishListAlert(context, index) {
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
                        setState(() {
                          index.isLoadingDelete = true;
                        });
                        widget.bLoC.deleteFromWishList(index.id).then((value) {
                          if (value ==
                              "Product is successfully removed from your wishlist") {
                            setState(() {
                              index.isLoadingDelete = false;
                            });
                          } else {
                            setState(() {
                              index.isLoadingDelete = false;
                            });
                          }
                        });
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ],
            ));
  }
}
