
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/all_brands.dart';
import 'package:dijlah_store_ibtechiq/model/user.dart';

class Product {
  Product({
    this.id,
    this.name,
    this.arabicName,
    this.enName,
    this.kuName,
    this.addedBy,
    this.user,
    this.category,
    this.brand,
    this.photos,
    this.thumbnailImage,
    this.tags,
    this.basePrice,
    this.baseDiscountedPrice,
    this.priceLower,
    this.priceHigher,
    this.priceHighLow,
    this.choiceOptions,
    this.colors,
    this.todaysDeal,
    this.featured,
    this.currentStock,
    this.hasDiscount,
    this.stockVisibilityState,
    this.cashOnDelivery,
    this.lowStockQuantity,
    this.minQty,
    this.isQuantityMultiplied,
    this.estShippingDays,
    this.barcode,
    this.unit,
    this.arabicUnit,
    this.enUnit,
    this.kuUnit,
    this.discount,
    this.discountType,
    this.tax,
    this.taxType,
    this.state,
    this.shippingType,
    this.shippingCost,
    this.numberOfSales,
    this.rating,
    this.ratingCount,
    this.description,
    this.arabicDescription,
    this.enDescription,
    this.kuDescription,
    this.videoLink,
    this.refundable,
    this.earnPoint,
    this.productType
  });

  var id;
  var name;
  var arabicName;
  var enName;
  var kuName;
  var addedBy;
  User user;
  dynamic videoLink;
  var refundable;
  var earnPoint;
  Category category;
  AllBrand brand;
  var photos;
  var thumbnailImage;
  var tags;
  var basePrice;
  var baseDiscountedPrice;
  var priceLower;
  var priceHigher;
  var priceHighLow;
  List<ChoiceOption> choiceOptions;
  var colors;
  var todaysDeal;
  var featured;
  var currentStock;
  var hasDiscount;
  var stockVisibilityState;
  var cashOnDelivery;
  var lowStockQuantity;
  var minQty;
  var isQuantityMultiplied;
  var estShippingDays;
  var barcode;
  var unit;
  var arabicUnit;
  var enUnit;
  var kuUnit;
  var discount;
  var discountType;
  var tax;
  var taxType;
  var state;
  var shippingType;
  var shippingCost;
  var numberOfSales;
  var rating;
  var ratingCount;
  var description;
  var arabicDescription;
  var enDescription;
  var kuDescription;
  var productType;
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: isBlankData(json["id"]),
    name:isBlankData( json["name"]),
    arabicName: isBlankData( json["arabic_name"]),
    enName: isBlankData( json["en_name"]),
    kuName:isBlankData( json["ku_name"]),
    addedBy: isBlankData(json["added_by"]),
    user: User.fromJson(json["user"]),
    category: Category.fromJson(json["category"]),
    brand: AllBrand.fromJson(json["brand"]),
    photos:List<String>.from(json["photos"].map((x) => x)),
    thumbnailImage:isBlankData( json["thumbnail_image"]),
    tags:List<String>.from(json["tags"].map((x) => x)),
    basePrice: isBlankData(json["base_price"]),
    baseDiscountedPrice:isBlankData( json["base_discounted_price"]),
    priceLower:isBlankData( json["price_lower"]),
    priceHigher: isBlankData(json["price_higher"]),
    priceHighLow: isBlankData(json["price_high_low"]),
    videoLink: isBlankData(json["video_link"]),
    refundable: isBlankData(json["refundable"]),
    earnPoint: isBlankData(json["earn_point"]),
    choiceOptions:List<ChoiceOption>.from(json["choice_options"].map((x) => ChoiceOption.fromJson(x))),
    colors:List<String>.from(json["colors"].map((x) => x)),
    todaysDeal:isBlankData( json["todays_deal"]),
    featured:isBlankData( json["featured"]),
    currentStock: isBlankData(json["current_stock"]),
    hasDiscount: isBlankData(json["has_discount"]),
    stockVisibilityState: isBlankData(json["stock_visibility_state"]),
    cashOnDelivery:isBlankData( json["cash_on_delivery"]),
    lowStockQuantity: isBlankData( json["low_stock_quantity"]),
    minQty: isBlankData(json["min_qty"]),
    isQuantityMultiplied: isBlankData(json["is_quantity_multiplied"]),
    estShippingDays: isBlankData(json["est_shipping_days"]),
    barcode: isBlankData(json["barcode"]),
    unit: isBlankData(json["unit"]),
    arabicUnit: isBlankData(json["arabic_unit"]),
    enUnit: isBlankData(json["en_unit"]),
    kuUnit:isBlankData( json["ku_unit"]),
    discount: isBlankData(json["discount"]),
    discountType:isBlankData( json["discount_type"]),
    tax: isBlankData(json["tax"]),
    taxType:isBlankData( json["tax_type"]),
    state: isBlankData(json["state"]),
    shippingType:isBlankData( json["shipping_type"]),
    shippingCost:isBlankData( json["shipping_cost"]),
    numberOfSales:isBlankData( json["number_of_sales"]),
    rating:isBlankData( json["rating"]),
    ratingCount: isBlankData(json["rating_count"]),
    description: isBlankData(json["description"]),
    arabicDescription:isBlankData( json["arabic_description"]),
    enDescription:isBlankData(json["en_description"]),
    kuDescription:isBlankData( json["ku_description"]),
    productType:isBlankData( json["product_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "arabic_name": arabicName == null ? null : arabicName,
    "en_name": enName == null ? null : enName,
    "ku_name": kuName,
    "added_by": addedBy,
    "user": user.toJson(),
    "category": category.toJson(),
    "brand": brand.toJson(),
    "photos": List<dynamic>.from(photos.map((x) => x)),
    "thumbnail_image": thumbnailImage,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "base_price": basePrice,
    "base_discounted_price": baseDiscountedPrice,
    "price_lower": priceLower,
    "price_higher": priceHigher,
    "price_high_low": priceHighLow,
    "choice_options": List<dynamic>.from(choiceOptions.map((x) => x.toJson())),
    "colors": List<dynamic>.from(colors.map((x) => x)),
    "todays_deal": todaysDeal,
    "featured": featured,
    "current_stock": currentStock,
    "has_discount": hasDiscount,
    "stock_visibility_state": stockVisibilityState,
    "cash_on_delivery": cashOnDelivery,
    "low_stock_quantity": lowStockQuantity == null ? null : lowStockQuantity,
    "min_qty": minQty,
    "is_quantity_multiplied": isQuantityMultiplied,
    "est_shipping_days": estShippingDays,
    "barcode": barcode,
    "unit": unit,
    "arabic_unit": arabicUnit == null ? null : arabicUnit,
    "en_unit": enUnit == null ? null : enUnit,
    "ku_unit": kuUnit,
    "discount": discount,
    "discount_type": discountType,
    "tax": tax,
    "tax_type": taxType,
    "state": state,
    "shipping_type": shippingType,
    "shipping_cost": shippingCost,
    "number_of_sales": numberOfSales,
    "rating": rating,
    "rating_count": ratingCount,
    "description": description == null ? null : description,
    "arabic_description": arabicDescription == null ? null : arabicDescription,
    "en_description": enDescription == null ? null : enDescription,
    "ku_description": kuDescription,
    "video_link": videoLink,
    "refundable": refundable,
    "earn_point": earnPoint,
    "product_type":productType

  };
}

class Category {
  Category({
    this.id,
    this.name,
    this.arName,
    this.enName,
    this.kuName,
    this.banner,
    this.icon,
  });

  int id;
  String name;
  String arName;
  String enName;
  dynamic kuName;
  String banner;
  String icon;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: isBlankData(json["id"]),
    name: isBlankData(json["name"]),
    arName: isBlankData(json["ar_name"]),
    enName:isBlankData(json["en_name"]),
    kuName:isBlankData( json["ku_name"]),
    banner:isBlankData( json["banner"]),
    icon: isBlankData(json["icon"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ar_name": arName,
    "en_name": enName,
    "ku_name": kuName,
    "banner": banner,
    "icon": icon,
  };
}

class ChoiceOption {
  ChoiceOption({
    this.name,
    this.title,
    this.arTitle,
    this.enTitle,
    this.kuTitle,
    this.options,
  });

  String name;
  String title;
  String arTitle;
  dynamic enTitle;
  dynamic kuTitle;
  List<String> options;

  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
    name: isBlankData(json["name"]),
    title: isBlankData(json["title"]),
    arTitle: isBlankData(json["ar_title"]),
    enTitle: isBlankData(json["en_title"]),
    kuTitle: isBlankData(json["ku_title"]),
    options: List<String>.from(json["options"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "title": title,
    "ar_title": arTitle,
    "en_title": enTitle,
    "ku_title": kuTitle,
    "options": List<dynamic>.from(options.map((x) => x)),
  };
}