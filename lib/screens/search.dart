import 'dart:collection';

import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/widget/empty_search.dart';
import 'package:dijlah_store_ibtechiq/widget/products_list.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Search extends StatefulWidget {
  final BLoC bLoC;

  Search({Key key, this.bLoC}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  String query = '';
  bool isLoading = true;
  final TextEditingController _textFieldController =
      new TextEditingController();
  ScrollController _controller;
  int page = 2;

  @override
  void initState() {
    checkInternet(context);
    super.initState();
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool loading = false;

  _scrollListener() {
    var isEnd = _controller.position.maxScrollExtent == _controller.offset;
    if (isEnd) {
      setState(() {
        loading = true;
        page += 1;
        checkInternet(context).then((value) async {
          if (value == 'ok') {
            print(page);
            widget.bLoC
                .getMoreProductBySearchFuture(
                    _textFieldController.text.toLowerCase(), page)
                .then((value) => value == 'success' ? loading = false : null);
          }
        });
      });
    }
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
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 10),
              child: Text(
                getTranslated(context, "search_title"),
                style: TextStyle(
                    color: color1,
                    fontFamily: "sans",
                    fontSize: SizerUtil.deviceType == DeviceType.tablet
                        ? 12.sp
                        : 18.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                color: Colors.grey[100],
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      16,
                      SizerUtil.deviceType == DeviceType.tablet ? 10 : 0,
                      16,
                      SizerUtil.deviceType == DeviceType.tablet ? 10 : 0),
                  child: TextField(
                    controller: _textFieldController,
                    autocorrect: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: getTranslated(context, "search_hint"),
                      hintStyle: TextStyle(
                        fontFamily: "sans",
                        fontSize: SizerUtil.deviceType == DeviceType.tablet
                            ? 7.sp
                            : 12.sp,
                      ),
                      suffixIcon:
                          _textFieldController.text.length == 0 && query == ''
                              ? IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: color1,
                                    size: SizerUtil.deviceType == DeviceType.tablet?35:25,
                                  ),
                                  onPressed: () {
                                    checkInternet(context).then((value) async {
                                      if (value == 'ok') {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        widget.bLoC
                                            .getAllProductBySearchFuture(
                                                _textFieldController.text
                                                    .toLowerCase())
                                            .then((value) => setState(() {
                                                  isLoading = false;
                                                }));
                                        setState(() {
                                          query = _textFieldController.text
                                              .toLowerCase();
                                          page=1;
                                        });
                                      }
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: color1,
                                    size: SizerUtil.deviceType == DeviceType.tablet?25:18,
                                  ),
                                  onPressed: () {
                                    _textFieldController.clear();
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    setState(() {
                                      query = '';
                                      isLoading = false;
                                      page=1;
                                    });
                                  },
                                ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onSubmitted: (string) {
                      setState(() {
                        isLoading = true;
                      });
                      checkInternet(context).then((value) async {
                        if (value == 'ok') {
                          widget.bLoC
                              .getAllProductBySearchFuture(string.toLowerCase())
                              .then((value) => setState(() {
                                    isLoading = false;
                                  }));
                          setState(() {
                            query = string;
                            page=1;
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
                child: query == ''
                    ? EmptySearchItems(
                        bLoC: widget.bLoC,
                      )
                    : StreamBuilder<UnmodifiableListView<Product>>(
                        stream: widget.bLoC.allSearchProducts,
                        initialData: UnmodifiableListView<Product>([]),
                        builder: (context,
                            AsyncSnapshot<UnmodifiableListView<Product>>
                                snapshot) {
                          if (snapshot.data.length > 0 &&
                              snapshot.data.isNotEmpty) {
                            return SingleChildScrollView(
                                controller: _controller,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Column(
                                      children: snapshot.data
                                          .map((i) => ProductList(
                                                product: i,
                                                bLoC: widget.bLoC,
                                              ))
                                          .toList(),
                                    ),
                                    loading ? Container(width:double.infinity,height:100,color:Colors.white,child:loadingGetMore(context, 100.0)) : Container(),
                                  ],
                                ));
                          }

                          return isLoading
                              ? Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  child: Text(
                                    getTranslated(context, "result_search"),
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.tablet
                                            ? 7.sp
                                            : 12.sp),
                                  ))
                              : Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  child: Text(
                                    getTranslated(context, "no_result_search"),
                                    style: TextStyle(
                                        fontFamily: "sans",
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.tablet
                                            ? 7.sp
                                            : 12.sp),
                                  ));
                        },
                      )),
          ],
        ),
        bottomNavigationBar: bottomNavigatorBar(context, 0, widget.bLoC, false),
      ),
    );
  }
}
