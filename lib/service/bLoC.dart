import 'dart:collection';
import 'dart:convert';
import 'package:dijlah_store_ibtechiq/model/about_us.dart';
import 'package:dijlah_store_ibtechiq/model/all_atributes.dart';
import 'package:dijlah_store_ibtechiq/model/all_brands.dart';
import 'package:dijlah_store_ibtechiq/model/cartItem.dart';
import 'package:dijlah_store_ibtechiq/model/category.dart';
import 'package:dijlah_store_ibtechiq/model/banners.dart';
import 'package:dijlah_store_ibtechiq/model/category_brand.dart';
import 'package:dijlah_store_ibtechiq/model/category_filter.dart';
import 'package:dijlah_store_ibtechiq/model/color.dart';
import 'package:dijlah_store_ibtechiq/model/custom_page.dart';
import 'package:dijlah_store_ibtechiq/model/flash_deal_slider.dart';
import 'package:dijlah_store_ibtechiq/model/home_sections.dart';
import 'package:dijlah_store_ibtechiq/model/order_detail.dart';
import 'package:dijlah_store_ibtechiq/model/order_history.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/model/refund_history.dart';
import 'package:dijlah_store_ibtechiq/model/reviews.dart';
import 'package:dijlah_store_ibtechiq/model/shop.dart';
import 'package:dijlah_store_ibtechiq/model/states.dart';
import 'package:dijlah_store_ibtechiq/model/wishList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/constant.dart';
  ValueNotifier<int> cartQuantity = ValueNotifier<int>(0);
ValueNotifier<int> wishListQuantity = ValueNotifier<int>(0);
class BLoC {
  final _allShopSubject = BehaviorSubject<UnmodifiableListView<AllShop>>();
  final _allCategorySubject = BehaviorSubject<UnmodifiableListView<AllCategory>>();
  final _allSubCategorySubject = BehaviorSubject<UnmodifiableListView<AllCategory>>();
  final _allSubCategoryCustomSubject = BehaviorSubject<UnmodifiableListView<AllCategory>>();
  final _allBrandsSubject = BehaviorSubject<UnmodifiableListView<AllBrand>>();
  final _categoryBrandsSubject = BehaviorSubject<UnmodifiableListView<CategoryBrands>>();
  final _categoryBrandsSubCategorySubject = BehaviorSubject<UnmodifiableListView<CategoryBrands>>();
  final _customPageBrandsSubject = BehaviorSubject<UnmodifiableListView<CategoryBrands>>();
  final _allProductsSubject = BehaviorSubject<UnmodifiableListView<Product>>();
  final _allRelatedProductsSubject = BehaviorSubject<UnmodifiableListView<Product>>();
  final _allSearchProductsSubject = BehaviorSubject<UnmodifiableListView<Product>>();
  final _allOrderHistorySubject = BehaviorSubject<UnmodifiableListView<AllOrderHistory>>();
  final _allRefundHistorySubject = BehaviorSubject<UnmodifiableListView<AllRefundHistory>>();
  final _allOrderDetailSubject = BehaviorSubject<UnmodifiableListView<OrderDetail>>();
  final _cartItemsSubject = BehaviorSubject<UnmodifiableListView<CartItem>>();
  final _wishListSubject = BehaviorSubject<UnmodifiableListView<WishLists>>();
  final _reviewsSubject = BehaviorSubject<UnmodifiableListView<Reviews>>();
  final _allColorsFilterSubject = BehaviorSubject<UnmodifiableListView<dynamic>>();
  final _allColorsSubject = BehaviorSubject<UnmodifiableListView<ColorsModel>>();
  final _allBrandsFilterSubject = BehaviorSubject<UnmodifiableListView<CategoryBrands>>();
  final _allCategoryFilterSubject = BehaviorSubject<UnmodifiableListView<CategoryFilter>>();
  final _allTagsSubject = BehaviorSubject<UnmodifiableListView<dynamic>>();
  final _allAttributesSubject = BehaviorSubject<UnmodifiableListView<Attribute>>();
  final _allProductsByFilterCategorySubject = BehaviorSubject<UnmodifiableListView<Product>>();
  final _allProductsByFilterSubCategorySubject = BehaviorSubject<UnmodifiableListView<Product>>();
  final _allProductsByFilterShopSubject = BehaviorSubject<UnmodifiableListView<Product>>();
  final _allProductsByFilterBrandSubject = BehaviorSubject<UnmodifiableListView<Product>>();
  final _allProductsByFilterCustomSubject = BehaviorSubject<UnmodifiableListView<Product>>();
  final _homeSectionsSubject = BehaviorSubject<UnmodifiableListView<HomeSections>>();
  final _customPageSubject = BehaviorSubject<UnmodifiableListView<CustomPage>>();
  final _customPageBannersSubject = BehaviorSubject<UnmodifiableListView<Banners>>();
  final _categoryBannersSubject = BehaviorSubject<UnmodifiableListView<Banners>>();
  final _categoryBannersSubCategorySubject = BehaviorSubject<UnmodifiableListView<Banners>>();
  final _flashDealsSubject = BehaviorSubject<UnmodifiableListView<FlashDealSliders>>();
  final _flashDealProductsSubject = BehaviorSubject<UnmodifiableListView<Product>>();
  final _aboutUsAndPrivacySubject = BehaviorSubject<UnmodifiableListView<AboutUsAndPrivacy>>();
  final _statesSubject = BehaviorSubject<UnmodifiableListView<States>>();

  ///////////////////////////////////////////////////////////////
  List<AllShop> _allShopList =  new List<AllShop>();
  List<AllCategory> _allCategoryList =  new List<AllCategory>();
  List<AllCategory> _allSubCategoryList = new List<AllCategory>();
  List<AllCategory> _allSubCategoryCustomList = new List<AllCategory>();
  List<AllBrand> _allBrandsList = new List<AllBrand>();
  List<CategoryBrands> _categoryBrandsList = new List<CategoryBrands>();
  List<CategoryBrands> _subCategoryBrandsList = new List<CategoryBrands>();
  List<CategoryBrands> _customPageBrandsList =  new List<CategoryBrands>();
  List<Product> _allProductsList = new List<Product>();
  List<Product> _allRelatedProductsList = new List<Product>();
  List<Product> _allSearchProductsList = new List<Product>();
  List<AllOrderHistory> _allOrderHistoryList = new List<AllOrderHistory>();
  List<AllRefundHistory> _allRefundHistoryList = new List<AllRefundHistory>();
  List<OrderDetail> _allOrderDetailList = new List<OrderDetail>();
  List<CartItem> _cartItems = new List<CartItem>();
  List<WishLists> _wishListList = new List<WishLists>();
  List<ColorsModel> _colorList = new List<ColorsModel>();
  List<Reviews> _reviewsList = new List<Reviews>();
  List<dynamic> _allColorsFilterList = new List<dynamic>();
  List<dynamic> _tagsList = new List<dynamic>();
  List<Attribute> _attributesList = new List<Attribute>();
  List<Product> _productsFilterCategoryList = new List<Product>();
  List<Product> _productsFilterSubCategoryList = new List<Product>();
  List<Product> _productsFilterShopList = new List<Product>();
  List<Product> _productsFilterBrandList = new List<Product>();
  List<Product> _productsFilterCustomList = new List<Product>();
  List<HomeSections> _homeSectionsList = new List<HomeSections>();
  List<CustomPage> _customPageList = new List<CustomPage>();
  List<Banners> _categoryBannersList = new List<Banners>();
  List<Banners> _categoryBannersSubCategoryList = new List<Banners>();
  List<Banners> _customPageBannerList = new List<Banners>();
  List<FlashDealSliders> _flashDealsList = new List<FlashDealSliders>();
  List<Product> _flashDealProductList = new List<Product>();
  List<AboutUsAndPrivacy> _aboutUsAndPrivacyList = new List<AboutUsAndPrivacy>();
  List<States> _statesList = new List<States>();
  List<CategoryFilter> _categoryFilterList =  new List<CategoryFilter>();
  List<CategoryBrands> _brandFilterList =  new List<CategoryBrands>();


////////////////////////////////////////////////////////////////////
  Stream<UnmodifiableListView<CartItem>> get cartItems => _cartItemsSubject.stream;
  Stream<UnmodifiableListView<AllShop>> get allShops => _allShopSubject.stream;
  Stream<UnmodifiableListView<AllCategory>> get allCategories => _allCategorySubject.stream;
  Stream<UnmodifiableListView<AllBrand>> get allBrands => _allBrandsSubject.stream;
  Stream<UnmodifiableListView<CategoryBrands>> get allCategoryBrands => _categoryBrandsSubject.stream;
  Stream<UnmodifiableListView<CategoryBrands>> get allCategorySubCategoryBrands => _categoryBrandsSubCategorySubject.stream;
  Stream<UnmodifiableListView<CategoryBrands>> get allCustomPageBrands => _customPageBrandsSubject.stream;
  Stream<UnmodifiableListView<AllCategory>> get allSubCategories => _allSubCategorySubject.stream;
  Stream<UnmodifiableListView<AllCategory>> get allSubCategoriesCustom => _allSubCategoryCustomSubject.stream;
  Stream<UnmodifiableListView<Product>> get allProducts => _allProductsSubject.stream;
  Stream<UnmodifiableListView<Product>> get allRelatedProducts => _allRelatedProductsSubject.stream;
  Stream<UnmodifiableListView<Product>> get allSearchProducts => _allSearchProductsSubject.stream;
  Stream<UnmodifiableListView<AllOrderHistory>> get allOrderHistory => _allOrderHistorySubject.stream;
  Stream<UnmodifiableListView<AllRefundHistory>> get allRefundHistory => _allRefundHistorySubject.stream;
  Stream<UnmodifiableListView<OrderDetail>> get allOrderDetail => _allOrderDetailSubject.stream;
  Stream<UnmodifiableListView<WishLists>> get allWishList => _wishListSubject.stream;
  Stream<UnmodifiableListView<Reviews>> get allReviews => _reviewsSubject.stream;
  Stream<UnmodifiableListView<ColorsModel>> get allColors => _allColorsSubject.stream;
  Stream<UnmodifiableListView<dynamic>> get allTags => _allTagsSubject.stream;
  Stream<UnmodifiableListView<dynamic>> get allColorsFilter => _allColorsFilterSubject.stream;
  Stream<UnmodifiableListView<Attribute>> get allAttributes => _allAttributesSubject.stream;
  Stream<UnmodifiableListView<Product>> get allProductsByFilterCategory => _allProductsByFilterCategorySubject.stream;
  Stream<UnmodifiableListView<Product>> get allProductsByFilterSubCategory => _allProductsByFilterSubCategorySubject.stream;
  Stream<UnmodifiableListView<Product>> get allProductsByFilterShop => _allProductsByFilterShopSubject.stream;
  Stream<UnmodifiableListView<Product>> get allProductsByFilterBrand => _allProductsByFilterBrandSubject.stream;
  Stream<UnmodifiableListView<Product>> get allProductsByFilterCustom => _allProductsByFilterCustomSubject.stream;

  Stream<UnmodifiableListView<HomeSections>> get homeSections => _homeSectionsSubject.stream;
  Stream<UnmodifiableListView<CustomPage>> get customPage => _customPageSubject.stream;
  Stream<UnmodifiableListView<Banners>> get customPageBanners => _customPageBannersSubject.stream;
  Stream<UnmodifiableListView<Banners>> get categoryBanners => _categoryBannersSubject.stream;
  Stream<UnmodifiableListView<Banners>> get categoryBannersSubCategory => _categoryBannersSubCategorySubject.stream;
  Stream<UnmodifiableListView<FlashDealSliders>> get allFlashDeals => _flashDealsSubject.stream;
  Stream<UnmodifiableListView<Product>> get allFlashDealProducts => _flashDealProductsSubject.stream;
  Stream<UnmodifiableListView<AboutUsAndPrivacy>> get aboutUsAndPrivacy => _aboutUsAndPrivacySubject.stream;
  Stream<UnmodifiableListView<States>> get allStates => _statesSubject.stream;
  Stream<UnmodifiableListView<CategoryBrands>> get allBrandFilter => _allBrandsFilterSubject.stream;
  Stream<UnmodifiableListView<CategoryFilter>> get allCategoryFilter => _allCategoryFilterSubject.stream;


  ////////////////////////////////////////////////////////////////////////////////////
  Future< List<ColorsModel>> getColors() async {
    List<ColorsModel> temp;
    String url = MAIN_URL + "colors";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => ColorsModel.fromJson(e)).toList();
        _colorList = temp;
        return _colorList;
      }
    }
    return _colorList;
  }
  Future<void> _getFlashDeals() async {
    List<FlashDealSliders> temp;
    String url = MAIN_URL + "flash-deals";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => FlashDealSliders.fromJson(e)).toList();
        _flashDealsList = temp;
      }
    }
    else{
    }
  }
  Future<void> _getAboutUsAndPrivacy() async {
    List<AboutUsAndPrivacy> temp;
    String url = MAIN_URL + "aboutUsAndPrivacy";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => AboutUsAndPrivacy.fromJson(e)).toList();
        _aboutUsAndPrivacyList = temp;
      }
    }
    else{
    }
  }
  Future<void> _getAllStates() async {
    List<States> temp;
    String url = MAIN_URL + "states";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => States.fromJson(e)).toList();
        _statesList = temp;
      }
    }
    else{
    }
  }
  Future<void> _getFlashDealProducts(flashId) async {
    List<Product> temp;
    String url = MAIN_URL + "flash-deal-products/$flashId";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => Product.fromJson(e)).toList();
        _flashDealProductList = temp;
      }
    }
    else{
    }
  }
  Future<void> _getCustomPage() async {
    List<CustomPage> temp;
    String url = MAIN_URL + "customPage";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => CustomPage.fromJson(e)).toList();
        _customPageList = temp;
      }
    }
    else{
    }
  }
  Future<void> _getCustomPageBanners(pageId) async {
    List<Banners> temp;
    String url = MAIN_URL + "customPageBanner/$pageId";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => Banners.fromJson(e)).toList();
        _customPageBannerList = temp;
      }
    }
    else{
    }
  }
  Future<String> getCustomPageBannersFuture(pageId) async {
    _customPageBannerList.clear();
    await _getCustomPageBanners(pageId).then((_) {
      _customPageBannersSubject.add(
          UnmodifiableListView(_customPageBannerList));
    });
    return 'success';
  }
  Future<void> _getCategoryBanners(categoryId,getFrom) async {
    List<Banners> temp;
    String url = MAIN_URL + "categoryBanner/$categoryId";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => Banners.fromJson(e)).toList();
        if(getFrom=='category') {
          _categoryBannersList = temp;
        }
        else if(getFrom=='subCategory') {
          _categoryBannersSubCategoryList = temp;
        }
      }
    }
    else{
    }
  }
  Future<String> getCategoryBannersFuture(categoryId,getFrom) async {
    if(getFrom=='category') {
      _categoryBannersList.clear();
    }
    else if(getFrom=='subCategory') {
      _categoryBannersSubCategoryList.clear();
    }

    await _getCategoryBanners(categoryId,getFrom).then((_) {
      if(getFrom=='category') {
        _categoryBannersSubject.add(

            UnmodifiableListView(_categoryBannersList));
      }
      else if(getFrom=='subCategory') {
        _categoryBannersSubCategorySubject.add(

            UnmodifiableListView(_categoryBannersSubCategoryList));
      }


    });
    return 'success';
  }
  Future<void> _getAllHomeSections() async {
    List<HomeSections> temp;
    String url = MAIN_URL + "homeSection";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => HomeSections.fromJson(e)).toList();
        _homeSectionsList = temp;
      }
    }
    else{
    }
  }
  Future<void> _getWishList() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userId=preferences.getString("userId");
    var userToken = preferences.getString("access_token");
    if((userToken!=null && userId!=null)  ) {
      String url = MAIN_URL + "wishlist/$userId";
      Response response = await get(Uri.parse(url),
          headers: {"Authorization": "Bearer " + userToken});
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> temp = data['data'];
        List<WishLists> tempList = temp.map((e) => WishLists.fromJson(e))
            .toList();
        int totalWishList = tempList.length;
        preferences.setInt("totalWishList", totalWishList);
        wishListQuantity.value = preferences.getInt("totalWishList");
        _wishListList = tempList;
      }
    }
  }
  Future<void> _getCartItems() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userId=preferences.getString("userId");
    var userToken = preferences.getString("access_token");
    if(userToken!=null && userId!=null) {
      String url = MAIN_URL + "carts?id=$userId";
      Response response = await get(Uri.parse(url),

          headers: {"Authorization": "Bearer " + userToken});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> temp = data['data'];
        var qty = 0;
        List<CartItem> tempList = temp.map((e) => CartItem.fromJson(e))
            .toList();
        tempList.map((e) => qty += e.quantity).toList();
        preferences.setInt("cartCount", qty);
        cartQuantity.value = preferences.getInt("cartCount");
        _cartItems = tempList;
      }
    }
  }
  Future<String> addToCart({product_id,product_variant,product_color,user_id,quantity}) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userToken = preferences.getString("access_token");
    if((userToken!=null) ||(userToken!='')||(userToken.isNotEmpty ) ) {
    String url = MAIN_URL + "carts/add";
    try {
      Response response = await post(Uri.parse(url),
          body: {
            "id": product_id.toString(),
            "variant": product_variant,
            "user_id": user_id,
            "color": product_color,
            "quantity": quantity.toString()
          },
          headers: {"Authorization": "Bearer " + userToken}
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['message'] == "Product added to cart successfully") {
          _cartItems.clear();
          await _getCartItems().then((_) {
            _cartItemsSubject.add(
                UnmodifiableListView(_cartItems));
          });
        }

        return data['message'];
      }
    }
      on Exception catch (e) {
        print(e);
      }}

  }
  Future<String> checkCart({cardId,quantity}) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userToken = preferences.getString("access_token");
    if((userToken!=null)  ) {
      String url = MAIN_URL + "carts/checkCart";
      try {
        Response response = await post(Uri.parse(url),
            body: {
              "cart_ids": cardId.toString(),
              "cart_quantities": quantity.toString()
            },
            headers: {"Authorization": "Bearer " + userToken}
        );


        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          return data['message'];
        }
      }
      on Exception catch (e) {
        print(e);
      }
    }
  }
  Future<String> addOrder({user_id,shipping_address,grand_total,coupon_discount,coupon_code,seller_id,notes}) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userToken = preferences.getString("access_token");
    if((userToken!=null)) {
      String url = MAIN_URL + "payments/pay/cod";
      Response response = await post(Uri.parse(url),
          body: {
            "user_id": user_id.toString(),
            "seller_id":seller_id,
            "shipping_address": shipping_address,
            "payment_type": "cash_on_delivery",
            "payment_status": "unpaid",
            "grand_total": grand_total.toString(),
            "coupon_discount": coupon_discount,
            "coupon_code": coupon_code,
            "notes": notes,

          },
          headers: {"Authorization": "Bearer " + userToken}
      );
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data['message'] == "Your order has been placed successfully") {
          _cartItems.clear();
          await _getCartItems().then((_) {
            _cartItemsSubject.add(
                UnmodifiableListView(_cartItems));
          });
        }
        return data['message'];
      }
    }
  }
  Future<String> updateQuantity({product_id,product_quantity,type}) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userToken = preferences.getString("access_token");
    if((userToken!=null)  ) {
      String url = MAIN_URL + "carts/change-quantity";
      Response response = await post(Uri.parse(url),
          body: {
            "id": product_id.toString(),
            "quantity": product_quantity.toString(),
            "type": type.toString()
          },
          headers: {"Authorization": "Bearer " + userToken}
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['message'] == "Cart updated") {
          _cartItems.clear();
          await _getCartItems().then((_) {
            _cartItemsSubject.add(
                UnmodifiableListView(_cartItems));
          });
        }
        return data['message'];
      }
    }
  }
  Future<String> deleteFromCart({product_id}) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userToken = preferences.getString("access_token");
    if((userToken!=null)  ) {
      String url = MAIN_URL + "carts/$product_id";
      Response response = await delete(Uri.parse(url),
          headers: {"Authorization": "Bearer " + userToken});
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['message'] ==
            "Product is successfully removed from your cart") {
          _cartItems.clear();
          await _getCartItems().then((_) {
            _cartItemsSubject.add(
                UnmodifiableListView(_cartItems));
          });
        }
        return data['message'];
      }
    }
  }

  Future<String> deleteFromWishList(wishListId) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userToken = preferences.getString("access_token");
    if((userToken!=null)  ) {
      String url = MAIN_URL + "wishlists/$wishListId";
      Response response = await delete(Uri.parse(url),
          headers: {"Authorization": "Bearer " + userToken});
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body,);
        if (data['message'] ==
            "Product is successfully removed from your wishlist") {
          _wishListList.clear();
          await _getWishList().then((_) {
            _wishListSubject.add(
                UnmodifiableListView(_wishListList));
          });
        }
        return data['message'];
      }
    }
  }
  Future<void> _getAllShops() async {
    List<AllShop> temp;
    String url = MAIN_URL + "shops";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];

      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => AllShop.fromJson(e)).toList();
        _allShopList = temp;
      }
    }
  }
  Future<void> _getAllBrands() async {
    List<AllBrand> temp;
    String url = MAIN_URL + "brands";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => AllBrand.fromJson(e)).toList();
        _allBrandsList = temp;
      }
    }
  }
  Future<void> _getAllCategories() async {
    List<AllCategory> temp;
    String url = MAIN_URL + "categories";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => AllCategory.fromJson(e)).toList();
        _allCategoryList = temp;
      }
    }
  }
  Future<String> getFlashDealProductsFuture(flashId) async {
    _flashDealProductList.clear();
    await _getFlashDealProducts(flashId).then((_) {
      _flashDealProductsSubject.add(
          UnmodifiableListView(_flashDealProductList));
    });
    return 'success';
  }

  Future<String> getCartItemFuture() async {
    _cartItems.clear();
    await _getCartItems().then((_) {
      _cartItemsSubject.add(
          UnmodifiableListView(_cartItems));
    });
    return 'success';
  }
  Future<void> _getAllProducts() async {
    List<Product> temp;
    String url = MAIN_URL + "products?page=1";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      print(infoData);
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => Product.fromJson(e)).toList();
        _allProductsList = temp;
      }
    }
  }
  Future<void> _getRelatedProducts(productId) async {
    List<Product> temp;
    String url = MAIN_URL + "products/related/$productId";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => Product.fromJson(e)).toList();
        _allRelatedProductsList = temp;
      }
    }
  }
  Future<String> getRelatedProductsFuture(productId) async {
    _allRelatedProductsList.clear();
    await _getRelatedProducts(productId).then((_) {
      _allRelatedProductsSubject.add(
          UnmodifiableListView(_allRelatedProductsList));
    });
    return 'success';
  }
  Future<void> _getSubCategory(categoryId,getFrom) async {
    List<AllCategory> temp;
    String url = MAIN_URL + "sub-categories/$categoryId";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => AllCategory.fromJson(e)).toList();
        if(getFrom=='category') {
          _allSubCategoryList = temp;
        }
        else if(getFrom=='custom') {
          _allSubCategoryCustomList = temp;
        }

      }
    }
  }
  Future<String> getSubCategoryFuture(categoryId,getFrom) async {
    if(getFrom=='category') {
      _allSubCategoryList.clear();
    }
    else if(getFrom=='custom') {
      _allSubCategoryCustomList .clear();
    }
    await _getSubCategory(categoryId,getFrom).then((_) {
      if(getFrom=='category') {
        _allSubCategorySubject.add(
            UnmodifiableListView(_allSubCategoryList));
      }
      else if(getFrom=='custom') {
        _allSubCategoryCustomSubject.add(
            UnmodifiableListView(_allSubCategoryCustomList));
      }

    });
    return 'success';
  }
  Future<void> _getReviews(productId) async {
      List<Reviews> temp;
      String url = MAIN_URL + "reviews/product/$productId";
      Response response = await get(Uri.parse(url,));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> infoData = data["data"];
        if (infoData.isEmpty) {
          return new List();
        } else {
          temp = infoData.map((e) => Reviews.fromJson(e)).toList();
          _reviewsList = temp;
        }
    }
  }
  Future<String> getReviewsFuture(productId) async {
    _reviewsList.clear();
    await _getReviews(productId).then((_) {
      _reviewsSubject.add(
          UnmodifiableListView(_reviewsList));
    });
    return 'success';
  }
  Future<void> _getAllProductBySearch(wordSearch) async {
    List<Product> temp;
    String url = MAIN_URL + "products/search?query=$wordSearch";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"},);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => Product.fromJson(e)).toList();
        _allSearchProductsList = temp;
      }
    }
  }
  Future<String> getAllProductBySearchFuture(wordSearch) async {
    _allSearchProductsList.clear();
    await _getAllProductBySearch(wordSearch).then((_) {
      _allSearchProductsSubject.add(
          UnmodifiableListView(_allSearchProductsList));
    });
    return 'success';
  }
  Future<void> _getMoreProductBySearch(wordSearch, page) async {
    List<Product> temp;
    String url = MAIN_URL + "products/search?query=$wordSearch&page=$page";
    Response response = await get(Uri.parse(url),
      headers: {"Accept": "application/json"},);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) {
          _allSearchProductsList.add(Product.fromJson(e));
        }).toList();
        return temp;
      }
    }
  }
  Future<String> getMoreProductBySearchFuture(wordSearch, page) async {
    await _getMoreProductBySearch(wordSearch, page).then((_) {
      _allSearchProductsSubject.add(
          UnmodifiableListView(_allSearchProductsList));
    });
    return 'success';
  }
  Future<void> _getAllProductsByFilter(sortKey,shopId,brandId,categoryId,subCategoryId,color,tags,state,attribute,min,max) async {
    List<Product> temp;
    String url = MAIN_URL + "products/filterProducts?page=1";
    Response response = await post(Uri.parse(url),
        headers: {"Accept": "application/json"},
           body: {
          "sort_key":sortKey,
          "shop_id":shopId ,
           "brand_id":brandId,
           "category":categoryId ,
             "subCategory":subCategoryId ,
           "color":color,
           "tags":tags ,
           "state":state,
           "attribute":attribute ,
           "min":min ,
           "max":max
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        if (categoryId != '') {
          temp = infoData.map((e) => Product.fromJson(e)).toList();
          _productsFilterCategoryList = temp;
        }
        else if (subCategoryId != '') {
          temp = infoData.map((e) => Product.fromJson(e)).toList();
          _productsFilterSubCategoryList = temp;
        }
        else if (shopId != '') {
          temp = infoData.map((e) => Product.fromJson(e)).toList();
          _productsFilterShopList = temp;
        }
        else if (brandId != '') {
          temp = infoData.map((e) => Product.fromJson(e)).toList();
          _productsFilterBrandList = temp;
        }

      }
    }
  }
  Future<void> _getMoreProductsByFilter(sortKey,shopId,brandId,categoryId,subCategoryId,color,tags,state,attribute,min,max, page) async {
    List<Product> temp;
    String url = MAIN_URL + "products/filterProducts?page=$page";
    Response response = await post(Uri.parse(url),
        headers: {"Accept": "application/json"}, body: {
          "sort_key":sortKey,
          "shop_id":shopId ,
          "brand_id":brandId,
          "category":categoryId ,
          "subCategory":subCategoryId,
          "color":color,
          "tags":tags ,
          "state":state,
          "attribute":attribute ,
          "min":min ,
          "max":max
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["data"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        if (categoryId != '') {
          temp = infoData.map((e) {
            _productsFilterCategoryList.add(Product.fromJson(e));
          }).toList();
          return temp;
        }
        else if (subCategoryId != '') {
          temp = infoData.map((e) {
            _productsFilterSubCategoryList.add(Product.fromJson(e));
          }).toList();
          return temp;
        }
        else if (shopId != '') {
          temp = infoData.map((e) {
            _productsFilterShopList.add(Product.fromJson(e));
          }).toList();
          return temp;
        }
        else if (brandId != '') {
          temp = infoData.map((e) {
            _productsFilterBrandList.add(Product.fromJson(e));
          }).toList();
          return temp;
        }

      }
    }
  }
  Future<String> getMoreProductsFilter(sortKey,shopId,brandId,categoryId,subCategoryId,color,tags,state,attribute,min,max, page) async {
    await _getMoreProductsByFilter(sortKey,shopId,brandId,categoryId,subCategoryId,color,tags,state,attribute,min,max, page).then((_) {
      if (categoryId != '') {
        _allProductsByFilterCategorySubject.add(
            UnmodifiableListView(_productsFilterCategoryList));
      }
      else if (subCategoryId != '') {
        _allProductsByFilterSubCategorySubject.add(
            UnmodifiableListView(_productsFilterSubCategoryList));
      }
      else if (shopId != '') {
        _allProductsByFilterShopSubject.add(
            UnmodifiableListView(_productsFilterShopList));
      }
      else if (brandId != '') {
        _allProductsByFilterBrandSubject.add(
            UnmodifiableListView(_productsFilterBrandList));
      }

    });
    return 'success';
  }
  Future<List<Product>> getProductsByFilter(sortKey,shopId,brandId,categoryId,subCategoryId,color,tags,state,attribute,min,max) async {
    if (categoryId != '') {
      _productsFilterCategoryList.clear();
    }
    else if (subCategoryId != '') {
      _productsFilterSubCategoryList.clear();
    }
    else if (shopId != '') {
      _productsFilterShopList.clear();
    }
    else if (brandId != '') {
      _productsFilterBrandList.clear();
    }
    await _getAllProductsByFilter(sortKey,shopId,brandId,categoryId,subCategoryId,color,tags,state,attribute,min,max).then((_) {
      if (categoryId != '') {
        _allProductsByFilterCategorySubject.add(
            UnmodifiableListView(_productsFilterCategoryList));
      }
      else if (subCategoryId != '') {
        _allProductsByFilterSubCategorySubject.add(
            UnmodifiableListView(_productsFilterSubCategoryList));
      }
      else if (shopId != '') {
        _allProductsByFilterShopSubject.add(
            UnmodifiableListView(_productsFilterShopList));
      }
      else if (brandId != '') {
        _allProductsByFilterBrandSubject.add(
            UnmodifiableListView(_productsFilterBrandList));
      }

    });
    if (categoryId != '') {
   return   _productsFilterCategoryList ;
    }
    else if (subCategoryId != '') {
    return  _productsFilterSubCategoryList;
    }
    else if (shopId != '') {
   return   _productsFilterShopList;
    }
    else if (brandId != '') {
    return  _productsFilterBrandList;
    }
  }
  Future<void> _getAllOderHistory() async {

    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userId=preferences.getString("userId");
    var userToken = preferences.getString("access_token");
    if((userToken!=null && userId!=null)  ) {
      List<AllOrderHistory> temp;
      String url = MAIN_URL + "purchase-history/$userId";
      Response response = await get(Uri.parse(url), headers: {"Authorization": "Bearer " + userToken});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> infoData = data["data"];

        if (infoData.isEmpty) {
          return new List();
        } else {
          temp = infoData.map((e) => AllOrderHistory.fromJson(e)).toList();
          _allOrderHistoryList = temp;
        }
      }
    }
  }
  Future<void> _getAllRefundHistory() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userId=preferences.getString("userId");
    var userToken = preferences.getString("access_token");
    if((userToken!=null && userId!=null)  ) {
      List<AllRefundHistory> temp;
      String url = MAIN_URL + "refund-history/$userId";
      Response response = await get(Uri.parse(url), headers: {"Authorization": "Bearer " + userToken});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> infoData = data["data"];
        if (infoData.isEmpty) {
          return new List();
        } else {
          temp = infoData.map((e) => AllRefundHistory.fromJson(e)).toList();
          _allRefundHistoryList = temp;
        }
      }
    }
  }
  Future<void> _getOderDetail(orderId) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var userToken = preferences.getString("access_token");
    if((userToken!=null ) ||(userToken!='' )||(userToken.isNotEmpty) ) {
      List<OrderDetail> temp;
      String url = MAIN_URL + "purchase-history-details/$orderId";
      Response response = await get(Uri.parse(url),
          headers: {"Authorization": "Bearer " + userToken});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> infoData = data["data"];
        if (infoData.isEmpty) {
          return new List();
        } else {
          temp = infoData.map((e) => OrderDetail.fromJson(e)).toList();
          _allOrderDetailList = temp;
        }
      }
    }
  }
  Future<List<OrderDetail>> getOrderDetailFuture(orderId) async {
    _allOrderDetailList.clear();
    await _getOderDetail(orderId).then((_) {
      _allOrderDetailSubject.add(
          UnmodifiableListView(_allOrderDetailList));
    });
    return _allOrderDetailList;
  }

  Future<List<AllRefundHistory>> getRefundHistoryFuture() async {
    _allOrderDetailList.clear();
    await _getAllRefundHistory().then((_) {
      _allRefundHistorySubject.add(
          UnmodifiableListView(_allRefundHistoryList));
    });
    return _allRefundHistoryList;
  }

  Future<String> getAllWishListFuture() async {
    _wishListList.clear();
    await _getWishList().then((_) {
      _wishListSubject.add(
          UnmodifiableListView(_wishListList));
    });
    return 'success';
  }

  Future<void> _getAllColorsFilter(id) async {
    String url = MAIN_URL + "products/getColorsFilter/$id";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["all_allColorsFilter"];
      if (data.isEmpty) {
        return new List();
      } else {
        _allColorsFilterList = infoData;
      }
    }
    else{
      print(response.body);
    }
  }

  Future<String> getAllColorsFilterFuture(id) async {
    _allColorsFilterList.clear();
    await _getAllColorsFilter(id).then((_) {
      _allColorsFilterSubject.add(
          UnmodifiableListView(_allColorsFilterList));
    });
    return 'success';
  }


  ///////////////////////////////////////////
  Future<void> _getAllTags(id) async {
    List<dynamic> temp;
    String url = MAIN_URL + "products/getTagsFilter/$id";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["all_tags"];
      if (data.isEmpty) {
        return new List();
      } else {
        temp = infoData;
        _tagsList = temp;
      }
    }
    else{
      print(response.body);
    }
  }
  Future<void> _getAllAttributes(id) async {
    List<Attribute> temp;
    String url = MAIN_URL + "products/getAtributesFilter/$id";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["attributes"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => Attribute.fromJson(e)).toList();
        _attributesList = temp;
      }
    }
    else{
      print(response.body);
    }
  }
  Future<String> getAllAttributesFuture(id) async {
    _attributesList.clear();
    await _getAllAttributes(id).then((_) {
      _allAttributesSubject.add(
          UnmodifiableListView(_attributesList));
    });
    return 'success';
  }
  //////////////////////////////////////////////////////////////////
  Future<void> _getAllCategoryFilter(id) async {
    List<CategoryFilter> temp;
    String url = MAIN_URL + "products/getCategoriesFilter/$id";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["all_categories"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => CategoryFilter.fromJson(e)).toList();
        _categoryFilterList = temp;
      }
    }
    else{
      print(response.body);
    }
  }
  Future<String> getAllCategoryFilterFuture(id) async {
    _categoryFilterList.clear();
    await _getAllCategoryFilter(id).then((_) {
      _allCategoryFilterSubject.add(
          UnmodifiableListView(_categoryFilterList));
    });
    return 'success';
  }
  /////////////////////////////////////////////////////////////////////////
  Future<void> _getAllBrandFilter(id) async {
    List<CategoryBrands> temp;
    String url = MAIN_URL + "products/getBrandFilter/$id";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data["all_brands"];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => CategoryBrands.fromJson(e)).toList();
        _brandFilterList = temp;
      }
    }
    else{
      print(response.body);
    }
  }
  Future<String> getAllBrandFilterFuture(id) async {
    _brandFilterList.clear();
    await _getAllBrandFilter(id).then((_) {
      _allBrandsFilterSubject.add(
          UnmodifiableListView(_brandFilterList));
    });
    return 'success';
  }

  ///////////////////////////////////////////////
  Future<String> getAllSohpsFuture() async {
    _allShopList.clear();
    await _getAllShops().then((_) {
      _allShopSubject.add(
          UnmodifiableListView(_allShopList));
    });
    return 'success';
  }
  Future<String> getAllBrandsFuture() async {
    _allBrandsList.clear();
    await _getAllBrands().then((_) {
      _allBrandsSubject.add(
          UnmodifiableListView(_allBrandsList));
    });
    return 'success';
  }
  Future<String> getAllOrderHistoryFuture() async {
    _allOrderHistoryList.clear();
    await _getAllOderHistory().then((_) {
      _allOrderHistorySubject.add(
          UnmodifiableListView(_allOrderHistoryList));
    });
    return 'success';
  }
/////////////////////////////////////////////////////////////
  Future<void> _getCategoryBrand(categoryId,getFrom) async {
    List<CategoryBrands> temp;
    String url = MAIN_URL + "categories/brands/$categoryId";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data['all_brands'];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => CategoryBrands.fromJson(e)).toList();
        if(getFrom=='category') {
          _categoryBrandsList = temp;
        }
        else if(getFrom=='subCategory') {
          _subCategoryBrandsList = temp;
        }

      }
    }
  }
  Future<String> getCategoryBrandFuture(categoryId,getFrom) async {
    if(getFrom=='category') {
      _categoryBrandsList .clear();
    }
    else if(getFrom=='subCategory') {
      _subCategoryBrandsList.clear();
    }
    await _getCategoryBrand(categoryId,getFrom).then((_) {
      if(getFrom=='category') {
        _categoryBrandsSubject.add(
            UnmodifiableListView(_categoryBrandsList));
      }
      else if(getFrom=='subCategory') {
        _categoryBrandsSubCategorySubject.add(
            UnmodifiableListView(_subCategoryBrandsList));
      }

    });
    return 'success';
  }
  /////////////////////////////////////////////////////////////
  Future<void> _getCustomPageBrand(pageId) async {
    List<CategoryBrands> temp;
    String url = MAIN_URL + "customPage/brands/$pageId";
    Response response = await get(Uri.parse(url),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> infoData = data['all_brands'];
      if (infoData.isEmpty) {
        return new List();
      } else {
        temp = infoData.map((e) => CategoryBrands.fromJson(e)).toList();
        _customPageBrandsList = temp;
      }
    }
  }
  Future<String> getCustomPageBrandFuture(pageId) async {
    _customPageBrandsList.clear();
    await _getCustomPageBrand(pageId).then((_) {
      _customPageBrandsSubject.add(
          UnmodifiableListView(_customPageBrandsList));
    });
    return 'success';
  }
  //////////////////////////////////////////////////////////////////////////////
   loadingData() async {
     _getAllCategories().then((_) {
       _allCategorySubject.add(
           UnmodifiableListView(_allCategoryList));
     });
     _getAllStates().then((_) {
       _statesSubject.add(
           UnmodifiableListView(_statesList));
     });
       _getAllProducts().then((_) {
       _allProductsSubject.add(
           UnmodifiableListView(_allProductsList));
     });
    _getAllShops().then((_) {
      _allShopSubject.add(UnmodifiableListView(_allShopList));
    });
     _getAllBrands().then((_) {
      _allBrandsSubject.add(
          UnmodifiableListView(_allBrandsList));
    });
    _getAboutUsAndPrivacy().then((_) {
      _aboutUsAndPrivacySubject.add(
          UnmodifiableListView(_aboutUsAndPrivacyList));
    });
  }
  ////////////////////////////////////////////////////////////////////////////////////////
  BLoC()  {

    _getAllHomeSections().then((_) {
      _homeSectionsSubject.add(UnmodifiableListView(_homeSectionsList));
    });

    _getCustomPage().then((_) {
      _customPageSubject.add(UnmodifiableListView(_customPageList));
    });

    _getFlashDeals().then((_) {
      _flashDealsSubject.add(UnmodifiableListView(_flashDealsList));
    });
  }
}