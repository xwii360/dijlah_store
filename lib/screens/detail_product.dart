import 'dart:collection';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dijlah_store_ibtechiq/common/theme.dart';
import 'package:dijlah_store_ibtechiq/screens/login.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/model/reviews.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:dijlah_store_ibtechiq/screens/search.dart';
import 'package:dijlah_store_ibtechiq/widget/galleryImage.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:dijlah_store_ibtechiq/widget/product_card.dart';
import 'package:dijlah_store_ibtechiq/widget/wishlist_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DetailProduct extends StatefulWidget {
  final Product product;
  final BLoC bLoC;
  const DetailProduct({Key key, this.product, this.bLoC}) : super(key: key);
  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct>
    with SingleTickerProviderStateMixin {
  final _controller = ScrollController();
  int _current = 0;
  bool isLoading = false;
  TextEditingController quantityController = TextEditingController();
  var color = "";
  var attributes = "";
  var quantity = 1;
  var currentStock = 0;
  var variantPrice = 0;
  String isReview;
  List<String> photos=[];
  bool isLoadingVariant = false;

  @override
  initState() {
    setState(() {
      variantPrice=variantPrice == 0 ? widget.product.discount != 0 ? double.parse(widget.product.baseDiscountedPrice.toString()).toInt() : widget.product.basePrice.round() : variantPrice;
    });
    Future.delayed(const Duration(milliseconds: 0), () async {
      if (widget.product.colors.isNotEmpty ||
          widget.product.choiceOptions.isNotEmpty) {
        setState(() {
          color =
              widget.product.colors.isNotEmpty ? widget.product.colors[0] : '';
          attributes = widget.product.choiceOptions.isNotEmpty
              ? widget.product.choiceOptions[0].options[0]
              : '';
          isLoadingVariant = true;
        });
        await getVariantPrice();
      }
    });
    checkInternet(context).then((value) async {
      if (value == 'ok') {
        createDynamicLink(widget.product.id.toString());
        widget.bLoC.getRelatedProductsFuture(widget.product.id);
        widget.bLoC.getReviewsFuture(widget.product.id);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image(
            image: AssetImage("assets/top_bar_logo.png"),
            width: MediaQuery.of(context).size.width / 2.7,
            height: MediaQuery.of(context).size.width / 4),
        leading: backArrow(context),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: Search(
                      bLoC: widget.bLoC,
                    ))),
            icon: Icon(
              Icons.search,
              color: Color(0xff3f4551),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(children: [
                  widget.product.photos.length > 1
                      ? CarouselSlider(
                          items: widget.product.photos
                              .map<Widget>((item) => InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GalleryImage(
                                                    imagesUrls:
                                                        widget.product.photos,
                                                  )));
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: CachedNetworkImage(
                                        imageUrl: IMAGE_URL + item,
                                        placeholder: (context, url) =>
                                            loadingSliderHomePage(
                                                context,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2.8,
                                                MediaQuery.of(context)
                                                    .size
                                                    .width),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.8,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height / 2.8,
                              viewportFraction: 2.0,
                              enableInfiniteScroll: true,
                              autoPlay: false,
                              autoPlayInterval: Duration(seconds: 10),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 1000),
                              autoPlayCurve: Curves.decelerate,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                        )
                      : InkWell(
                          onTap: () {
                            if(widget.product.photos.length ==0) {
                              photos.add(widget.product.thumbnailImage);
                            }
                            widget.product.photos.map((e){
                              photos.add(e);
                            }).toList();
                            print(photos);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GalleryImage(
                                          imagesUrls:  photos,
                                        )));
                          },
                          child: Container(
                            color: Colors.white,
                            child: Center(
                                child: CachedNetworkImage(
                              imageUrl:
                                  IMAGE_URL + widget.product.thumbnailImage,
                              placeholder: (context, url) =>
                                  loadingSliderHomePage(
                                      context,
                                      MediaQuery.of(context).size.width / 2.8,
                                      MediaQuery.of(context).size.width),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 2.8,
                            )),
                          ),
                        ),
                  widget.product.photos.length > 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.product.photos.map<Widget>((url) {
                            int index = widget.product.photos.indexOf(url);
                            return Container(
                              width: 6.0,
                              height: 6.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1, color: Colors.grey[400]),
                                color: _current == index
                                    ? Colors.grey[400]
                                    : Colors.transparent,
                              ),
                            );
                          }).toList(),
                        )
                      : Container(),
                ]),
                Positioned(
                  left: 15,
                  top: 10,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Color(0xfff7f7f9),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: IconButton(
                              onPressed: () async {
                                checkInternet(context).then((value) async {
                                  if (value == 'ok') {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    String url = pref.getString("url");
                                    Share.share(
                                        "${checkLanguage(context, widget.product.arabicName, widget.product.enName, widget.product.kuName, widget.product.name)} \n ${getTranslated(context, "product_link")} \n $url");
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.share,
                                color: Color(0xffafb0b9),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        WishListButton(
                          productId: widget.product.id,
                          bLoC: widget.bLoC,
                          productName: checkLanguage(
                              context,
                              widget.product.arabicName,
                              widget.product.enName,
                              widget.product.kuName,
                              widget.product.name),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            // SizedBox(
            //   height: 10,
            // ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: Products(
                        bLoC: widget.bLoC,
                        id: widget.product.brand.id,
                        title: checkLanguage(
                            context,
                            widget.product.brand.arName,
                            widget.product.brand.enName,
                            widget.product.brand.kuName,
                            widget.product.brand.name),
                        getFrom: "brand",
                      ))),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 2.0, right: 12, left: 12, bottom: 2),
                child: Text(
                  checkLanguage(
                      context,
                      widget.product.brand.arName,
                      widget.product.brand.enName,
                      widget.product.brand.kuName,
                      widget.product.brand.name),
                  style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 8, left: 8),
              child: Text(
                checkLanguage(
                    context,
                    widget.product.arabicName,
                    widget.product.enName,
                    widget.product.kuName,
                    widget.product.name),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 14),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "${variantPrice == 0 ? widget.product.discount != 0 ? double.parse(widget.product.baseDiscountedPrice.toString()).toInt() : widget.product.basePrice : variantPrice}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        SizedBox(width: 5),
                        Text(
                          getTranslated(context, "currency"),
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    widget.product.discount != 0.00
                        ? Text(
                            "${widget.product.basePrice.toString()}  ${getTranslated(context, "short_currency")}",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[600],
                                fontSize: 12),
                          )
                        : Container(),
                  ],
                ),
                widget.product.shippingType == "free"
                    ? Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        padding: EdgeInsets.only(left: 8, right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [Color(0xff86f7b6), Color(0xff8fd3f1)],
                          ),
                        ),
                        child: Text(
                          getTranslated(context, "free_delivery"),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      )
                    : Container(),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        getTranslated(context, "reviews"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SmoothStarRating(
                          allowHalfRating: false,
                          onRated: (v) {},
                          starCount: 5,
                          rating:
                              double.parse(widget.product.rating.toString()),
                          size: 23.0,
                          isReadOnly: true,
                          color: Colors.yellow[700],
                          filledIconData: Icons.star_rate_rounded,
                          halfFilledIconData: Icons.star_half_rounded,
                          defaultIconData: Icons.star_border_rounded,
                          borderColor: Colors.yellow[700],
                          spacing: 0.0),
                      Text("(${widget.product.ratingCount})")
                    ],
                  ),
                 if(widget.product.productType !=0) Container(
                    padding: EdgeInsets.all(6),
                    color: color1,
                      child: Text(
                          "${getTranslated(context, 'shipping_from')} ${widget.product.productType == 1 ? "Amazon" : widget.product.productType == 2 ? "Trendyol" : ''}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.product.choiceOptions.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.product.choiceOptions
                            .map<Widget>((e) => Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${getTranslated(context, "choose_attribute")}  ${checkLanguage(context, e.arTitle, e.enTitle, e.kuTitle, e.title)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: e.options.map<Widget>((s) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 40,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  border: attributes == s
                                                      ? Border.all(
                                                          color:
                                                              Colors.teal[300],
                                                          width: 1.2)
                                                      : Border.all(
                                                          color:
                                                              Colors.grey[300]),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: RaisedButton(
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        checkInternet(context)
                                                            .then(
                                                                (value) async {
                                                          if (value == 'ok') {
                                                            setState(() {
                                                              attributes = s;
                                                              isLoadingVariant =
                                                                  true;
                                                            });
                                                            widget
                                                                        .product
                                                                        .colors
                                                                        .isNotEmpty ||
                                                                    widget
                                                                        .product
                                                                        .choiceOptions
                                                                        .isNotEmpty
                                                                ? await getVariantPrice()
                                                                : '';
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        s,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: "sans",
                                                            color: attributes ==
                                                                    s
                                                                ? Colors.black
                                                                : Colors.grey),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ))
                            .toList(),
                      )
                    : Container(),
                widget.product.colors.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              getTranslated(context, "choose_color_required"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.product.colors
                                  .map<Widget>(
                                    (e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: color == e
                                                ? Border.all(
                                                    color: Colors.teal[300],
                                                    width: 1.2)
                                                : Border.all(
                                                    color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(3.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: SizedBox(
                                            height: 30,
                                            width: 80,
                                            child: RaisedButton(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                              ),
                                              onPressed: () {
                                                checkInternet(context)
                                                    .then((value) async {
                                                  if (value == 'ok') {
                                                    setState(() {
                                                      color = e;
                                                      isLoadingVariant = true;
                                                    });
                                                    print(e);
                                                    widget.product.colors
                                                                .isNotEmpty ||
                                                            widget
                                                                .product
                                                                .choiceOptions
                                                                .isNotEmpty
                                                        ? await getVariantPrice()
                                                        : '';
                                                  }
                                                });
                                              },
                                              color: Color(int.parse(
                                                  e.replaceFirst("#", '0xff'))),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Color(0xfffbfbee),
                  border: Border(
                      top: BorderSide(width: 0.8, color: Colors.yellow[200]),
                      bottom:
                          BorderSide(width: 0.8, color: Colors.yellow[200]))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${getTranslated(context, 'product_available')} ${widget.product.state==''?getTranslated(context, 'all_state'):widget.product.state}",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    " ${getTranslated(context, 'delivery_time_wise')} ${widget.product.estShippingDays} ${getTranslated(context, "days")} ",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            widget.product.user.shopName == ''
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey[200]),
                            bottom: BorderSide(color: Colors.grey[200])),
                        color: Colors.grey[50]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, bottom: 16, right: 8, left: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Products(
                                    bLoC: widget.bLoC,
                                    id: widget.product.user.id,
                                    title: widget.product.user.shopName,
                                    getFrom: "shop",
                                  )));
                        },
                        child: Row(
                          children: [
                            Text(getTranslated(context, "buy_from"),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold)),
                            widget.product.user.shopLogo == ""
                                ? Container()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.product.user.shopLogo,
                                      placeholder: (context, url) =>
                                          loadingSliderHomePage(
                                              context, 20.0, 20.0),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.fill,
                                    )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.product.user.shopName,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            widget.product.user.shopName == ''
                ? Container()
                : SizedBox(
                    height: 5,
                  ),
            if (widget.product.refundable == 1)
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.blueGrey[100]),
                        bottom: BorderSide(color: Colors.blueGrey[100])),
                    color: Colors.blueGrey[50]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 16, right: 8, left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: AssetImage("assets/refund.png"),
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(getTranslated(context, 'refund_product'),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getTranslated(context, "product_description"),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  HtmlWidget(
                    '''<span style="font-family:'sans';font-size:14px;color:grey"> ${checkLanguage(context, widget.product.arabicDescription, widget.product.enDescription, widget.product.kuDescription, widget.product.description)}
                    <br>
                    <iframe src="${widget.product.videoLink}"></iframe>
                    </span>''',
                    webView: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<UnmodifiableListView<Reviews>>(
                stream: widget.bLoC.allReviews,
                initialData: UnmodifiableListView<Reviews>([]),
                builder: (context, snap) {
                  if (snap.data.length != 0 || snap.data.isNotEmpty)
                    return ExpansionTile(
                        title: Text(
                          getTranslated(context, 'all_reviews'),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                        children: snap.data
                            .map((e) => ListTile(
                                  title: Text(
                                    e.user.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  leading: Icon(Icons.person_pin_outlined),
                                  subtitle: Text(e.comment == ''
                                      ? getTranslated(context, "no_comment")
                                      : e.comment),
                                  trailing: SmoothStarRating(
                                      allowHalfRating: false,
                                      onRated: (v) {},
                                      starCount: 5,
                                      rating: double.parse(e.rating.toString()),
                                      size: 23.0,
                                      isReadOnly: true,
                                      color: Colors.yellow[700],
                                      filledIconData: Icons.star_rate_rounded,
                                      halfFilledIconData:
                                          Icons.star_half_rounded,
                                      defaultIconData:
                                          Icons.star_border_rounded,
                                      borderColor: Colors.yellow[700],
                                      spacing: 0.0),
                                ))
                            .toList());
                  return Container();
                }),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey[200]),
                      bottom: BorderSide(color: Colors.grey[200]))),
              child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: RaisedButton.icon(
                    elevation: 0,
                    color: Colors.grey[100],
                    onPressed: () => _animateToIndex(10),
                    label: Text(
                      getTranslated(context, "go_to_up"),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    icon: Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.black,
                      size: 16,
                    ),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<UnmodifiableListView<Product>>(
                stream: widget.bLoC.allRelatedProducts,
                initialData: UnmodifiableListView<Product>([]),
                builder: (context, snap) {
                  return snap.data.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Text(
                                  getTranslated(context, "related_product"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: snap.data
                                    .map<Widget>((e) => ProductCard(
                                          bLoC: widget.bLoC,
                                          product: e,
                                        ))
                                    .toList(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      : Container();
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: SizedBox(
          height: SizerUtil.deviceType == DeviceType.tablet
                    ?120:106,
          child: Column(
            children: [
              isLoadingVariant
                  ? Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )),
                              SizedBox(width: 10,),
                              Text(getTranslated(context, 'loading'),style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                        )),
                  )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: (currentStock > 0) ||
                              ((widget.product.colors.isEmpty &&
                                      widget.product.choiceOptions.isEmpty) &&
                                  widget.product.currentStock > 0)
                          ? Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      color: Colors.teal[300],
                                      elevation: 0,
                                      onPressed: () async {
                                        checkInternet(context)
                                            .then((value) async {
                                          if (value == 'ok') {
                                            SharedPreferences pref =
                                                await SharedPreferences
                                                    .getInstance();
                                            var user_id =
                                                pref.getString("userId");
                                            if (user_id == null) {
                                              showTopFlash(
                                                  context,
                                                  checkLanguage(
                                                      context,
                                                      widget.product.arabicName,
                                                      widget.product.enName,
                                                      widget.product.kuName,
                                                      widget.product.name),
                                                  getTranslated(context,
                                                      "login_before_add_to_cart"),
                                                  true);
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      child: Login(
                                                        bLoC: widget.bLoC,
                                                      )));
                                            } else {
                                              if (widget.product.choiceOptions
                                                      .isNotEmpty &&
                                                  widget
                                                      .product.colors.isEmpty) {
                                                if (attributes != "") {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  widget.bLoC
                                                      .addToCart(
                                                          product_variant: attributes
                                                              .toString()
                                                              .replaceAll(
                                                                  new RegExp(
                                                                      r"\s+\b|\b\s"),
                                                                  ""),
                                                          product_id:
                                                              widget.product.id,
                                                          user_id: user_id,
                                                          product_color:
                                                              color.toString(),
                                                          quantity: quantity)
                                                      .then((value) {
                                                    if (value ==
                                                        "Product added to cart successfully") {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          getTranslated(context,
                                                              "add_to_cart_successfully"),
                                                          false);
                                                    } else if (value.contains(
                                                        "item(s) should be ordered")) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          " ${getTranslated(context, 'limited_order_product')} ${value.substring(7, 9)}",
                                                          false);
                                                    } else if (value ==
                                                        'Stock out') {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          " ${attributes.toString()} ${getTranslated(context, "out_of_stock")} ",
                                                          true);
                                                    } else if (value.contains(
                                                        'item(s) are available for')) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          "${attributes.toString()} ${getTranslated(context, 'available_just')} ${value.substring(4, 7)} ${getTranslated(context, 'from_this_product')} ",
                                                          true);
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          getTranslated(context,
                                                              "order_error"),
                                                          true);
                                                    }
                                                  });
                                                } else {
                                                  showTopFlash(
                                                      context,
                                                      checkLanguage(
                                                          context,
                                                          widget.product
                                                              .arabicName,
                                                          widget.product.enName,
                                                          widget.product.kuName,
                                                          widget.product.name),
                                                      getTranslated(context,
                                                          "choose_attribute_required"),
                                                      true);
                                                }
                                              } else if (widget.product.colors
                                                      .isNotEmpty &&
                                                  widget.product.choiceOptions
                                                      .isEmpty) {
                                                if (color != "") {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  widget.bLoC
                                                      .addToCart(
                                                          product_variant:
                                                              attributes
                                                                  .toString(),
                                                          product_id:
                                                              widget.product.id,
                                                          user_id: user_id,
                                                          product_color:
                                                              color.toString(),
                                                          quantity: quantity)
                                                      .then((value) {
                                                    if (value ==
                                                        "Product added to cart successfully") {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          getTranslated(context,
                                                              "add_to_cart_successfully"),
                                                          false);
                                                    } else if (value.contains(
                                                        "item(s) should be ordered")) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          " ${getTranslated(context, 'limited_order_product')} ${value.substring(7, 9)}",
                                                          false);
                                                    } else if (value ==
                                                        'Stock out') {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          " ${attributes.toString()} ${getTranslated(context, "out_of_stock")} ",
                                                          true);
                                                    } else if (value.contains(
                                                        'item(s) are available for')) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          "${attributes.toString()} ${getTranslated(context, 'available_just')} ${value.substring(4, 7)} ${getTranslated(context, 'from_this_product')} ",
                                                          true);
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showTopFlash(
                                                          context,
                                                          checkLanguage(
                                                              context,
                                                              widget.product
                                                                  .arabicName,
                                                              widget.product
                                                                  .enName,
                                                              widget.product
                                                                  .kuName,
                                                              widget.product
                                                                  .name),
                                                          getTranslated(context,
                                                              "order_error"),
                                                          true);
                                                    }
                                                  });
                                                } else {
                                                  showTopFlash(
                                                      context,
                                                      checkLanguage(
                                                          context,
                                                          widget.product
                                                              .arabicName,
                                                          widget.product.enName,
                                                          widget.product.kuName,
                                                          widget.product.name),
                                                      getTranslated(context,
                                                          "choose_attribute_required"),
                                                      true);
                                                }
                                              } else if (widget.product.colors
                                                      .isNotEmpty &&
                                                  widget.product.choiceOptions
                                                      .isNotEmpty) {
                                                if (attributes != "") {
                                                  if (color != "") {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    widget.bLoC
                                                        .addToCart(
                                                            product_variant:
                                                                attributes.replaceAll(
                                                                    new RegExp(
                                                                        r"\s+\b|\b\s"),
                                                                    ""),
                                                            product_id: widget
                                                                .product.id,
                                                            user_id: user_id,
                                                            product_color: color
                                                                .toString(),
                                                            quantity: quantity)
                                                        .then((value) {
                                                      if (value ==
                                                          "Product added to cart successfully") {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        showTopFlash(
                                                            context,
                                                            checkLanguage(
                                                                context,
                                                                widget.product
                                                                    .arabicName,
                                                                widget.product
                                                                    .enName,
                                                                widget.product
                                                                    .kuName,
                                                                widget.product
                                                                    .name),
                                                            getTranslated(
                                                                context,
                                                                "add_to_cart_successfully"),
                                                            false);
                                                      } else if (value.contains(
                                                          "item(s) should be ordered")) {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        showTopFlash(
                                                            context,
                                                            checkLanguage(
                                                                context,
                                                                widget.product
                                                                    .arabicName,
                                                                widget.product
                                                                    .enName,
                                                                widget.product
                                                                    .kuName,
                                                                widget.product
                                                                    .name),
                                                            " ${getTranslated(context, 'limited_order_product')} ${value.substring(7, 9)}",
                                                            false);
                                                      } else if (value ==
                                                          'Stock out') {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        showTopFlash(
                                                            context,
                                                            checkLanguage(
                                                                context,
                                                                widget.product
                                                                    .arabicName,
                                                                widget.product
                                                                    .enName,
                                                                widget.product
                                                                    .kuName,
                                                                widget.product
                                                                    .name),
                                                            " ${attributes.toString()} ${getTranslated(context, "out_of_stock")} ",
                                                            true);
                                                      } else if (value.contains(
                                                          'item(s) are available for')) {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        showTopFlash(
                                                            context,
                                                            checkLanguage(
                                                                context,
                                                                widget.product
                                                                    .arabicName,
                                                                widget.product
                                                                    .enName,
                                                                widget.product
                                                                    .kuName,
                                                                widget.product
                                                                    .name),
                                                            "${attributes.toString()} ${getTranslated(context, 'available_just')} ${value.substring(4, 7)} ${getTranslated(context, 'from_this_product')} ",
                                                            true);
                                                      } else {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        showTopFlash(
                                                            context,
                                                            checkLanguage(
                                                                context,
                                                                widget.product
                                                                    .arabicName,
                                                                widget.product
                                                                    .enName,
                                                                widget.product
                                                                    .kuName,
                                                                widget.product
                                                                    .name),
                                                            getTranslated(
                                                                context,
                                                                "order_error"),
                                                            true);
                                                      }
                                                    });
                                                  } else {
                                                    showTopFlash(
                                                        context,
                                                        checkLanguage(
                                                            context,
                                                            widget.product
                                                                .arabicName,
                                                            widget
                                                                .product.enName,
                                                            widget
                                                                .product.kuName,
                                                            widget
                                                                .product.name),
                                                        getTranslated(context,
                                                            "choose_color_required"),
                                                        true);
                                                  }
                                                } else {
                                                  showTopFlash(
                                                      context,
                                                      checkLanguage(
                                                          context,
                                                          widget.product
                                                              .arabicName,
                                                          widget.product.enName,
                                                          widget.product.kuName,
                                                          widget.product.name),
                                                      getTranslated(context,
                                                          "choose_attribute_required"),
                                                      true);
                                                }
                                              } else if (widget
                                                      .product.colors.isEmpty &&
                                                  widget.product.choiceOptions
                                                      .isEmpty) {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                widget.bLoC
                                                    .addToCart(
                                                        product_variant:
                                                            attributes
                                                                .toString(),
                                                        product_id:
                                                            widget.product.id,
                                                        user_id: user_id,
                                                        product_color:
                                                            color.toString(),
                                                        quantity: quantity)
                                                    .then((value) {
                                                  if (value ==
                                                      "Product added to cart successfully") {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    showTopFlash(
                                                        context,
                                                        checkLanguage(
                                                            context,
                                                            widget.product
                                                                .arabicName,
                                                            widget
                                                                .product.enName,
                                                            widget
                                                                .product.kuName,
                                                            widget
                                                                .product.name),
                                                        getTranslated(context,
                                                            "add_to_cart_successfully"),
                                                        false);
                                                  } else if (value.contains(
                                                      "item(s) should be ordered")) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    showTopFlash(
                                                        context,
                                                        checkLanguage(
                                                            context,
                                                            widget.product
                                                                .arabicName,
                                                            widget
                                                                .product.enName,
                                                            widget
                                                                .product.kuName,
                                                            widget
                                                                .product.name),
                                                        " ${getTranslated(context, 'limited_order_product')} ${value.substring(7, 9)}",
                                                        false);
                                                  } else if (value ==
                                                      'Stock out') {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    showTopFlash(
                                                        context,
                                                        checkLanguage(
                                                            context,
                                                            widget.product
                                                                .arabicName,
                                                            widget
                                                                .product.enName,
                                                            widget
                                                                .product.kuName,
                                                            widget
                                                                .product.name),
                                                        " ${attributes.toString()} ${getTranslated(context, "out_of_stock")} ",
                                                        true);
                                                  } else if (value.contains(
                                                      'item(s) are available for')) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    showTopFlash(
                                                        context,
                                                        checkLanguage(
                                                            context,
                                                            widget.product
                                                                .arabicName,
                                                            widget
                                                                .product.enName,
                                                            widget
                                                                .product.kuName,
                                                            widget
                                                                .product.name),
                                                        "${attributes.toString()} ${getTranslated(context, 'available_just')} ${value.substring(4, 7)} ${getTranslated(context, 'from_this_product')} ",
                                                        true);
                                                  } else {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    showTopFlash(
                                                        context,
                                                        checkLanguage(
                                                            context,
                                                            widget.product
                                                                .arabicName,
                                                            widget
                                                                .product.enName,
                                                            widget
                                                                .product.kuName,
                                                            widget
                                                                .product.name),
                                                        getTranslated(context,
                                                            "order_error"),
                                                        true);
                                                  }
                                                });
                                              }
                                            }
                                          }
                                        });
                                      },
                                      child: isLoading
                                          ? Center(
                                            child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                )),
                                            SizedBox(width: 10,),
                                            Text(getTranslated(context, 'loading'),style: TextStyle(fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                          )
                                          : Text(
                                              getTranslated(
                                                  context, "add_to_cart"),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    (currentStock > 0) ||
                                            ((widget.product.colors.isEmpty &&
                                                    widget.product.choiceOptions
                                                        .isEmpty) &&
                                                widget.product.currentStock > 0)
                                        ? chooseQuantity(context)
                                        : showTopFlash(
                                            context,
                                            checkLanguage(
                                                context,
                                                widget.product.arabicName,
                                                widget.product.enName,
                                                widget.product.kuName,
                                                widget.product.name),
                                            getTranslated(
                                                context, "out_of_quantity"),
                                            true);
                                  },
                                  child: Container(
                                    width: 55,
                                    height: 50,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Center(
                                            child: Text(
                                          getTranslated(context, "quantity"),
                                          style: TextStyle(fontSize: 12),
                                        )),
                                        Center(
                                            child: Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "j",
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Color(0xffedeef0),
                              ),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                color: Colors.transparent,
                                elevation: 0,
                                child: Text(
                                  getTranslated(
                                      context, "product_out_of_stock"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                    ),
              bottomNavigatorBar(context, 0, widget.bLoC, false),
            ],
          ),
        ),
      ),
    );
  }

  void chooseQuantity(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStates) {
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                    height: 150,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          getTranslated(context, "choose_quantity"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                widget.product.choiceOptions.isNotEmpty ||
                                        widget.product.colors.isNotEmpty
                                    ? currentStock
                                    : widget.product.currentStock,
                                (index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                          ),
                                          color: quantity == index + 1
                                              ? Colors.teal[300]
                                              : Colors.grey[300],
                                          onPressed: () {
                                            setState(() {
                                              quantity = index + 1;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text((index + 1).toString())),
                                    )).toList(),
                          ),
                        )
                      ],
                    )));
          });
        });
  }

  _animateToIndex(i) => _controller.animateTo(0.00,
      duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);

  getVariantPrice() async {
    checkInternet(context).then((value) async {
      if (value == 'ok') {
        print(color);
        try {
          String url = MAIN_URL + "products/variant/price";
          Map<String, String> body = {
            "color": color,
            "variant":
                attributes.toString().replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
            "id": widget.product.id.toString()
          };
          Response response = await post(
            Uri.parse(url),
            body: body,
          );
          print(response.body);
          var data = jsonDecode(response.body);
          if (mounted) {
            setState(() {
              this.variantPrice = data['price'].round();
              this.currentStock = data['stock'];
            });
          }
          setState(() {
            if (data['price'] != null) {
              isLoadingVariant = false;
            } else {
              isLoadingVariant = false;
            }
          });
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
