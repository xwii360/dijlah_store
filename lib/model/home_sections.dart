import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/all_brands.dart';
import 'package:dijlah_store_ibtechiq/model/banner.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';

class HomeSections {
  HomeSections({
    this.id,
    this.categoryId,
    this.products,
    this.status,
    this.title,
    this.orderingSection,
    this.sectionType,
    this.brands,
    this.shop,
    this.categoryLayout,
    this.categories,
    this.banner1,
    this.banner2,
    this.banner3,
    this.banner4,
    this.banner5,
  });

  var id;
  var categoryId;
 List<Product>  products;
  var status;
  List<String> title;
  var orderingSection;
  var categoryLayout;
  var sectionType;
  List<AllBrand> brands;
  List<Shop> shop;
  List<AllBrand> categories;
  Banner banner1;
  Banner banner2;
  Banner banner3;
  Banner banner4;
  Banner banner5;

  factory HomeSections.fromJson(Map<String, dynamic> json) => HomeSections(
    id: isBlankData(json["id"]),
    categoryId: isBlankData( json["category_id"]),
    categoryLayout: isBlankData( json["category_layout"]),
    products:json["products"]==null?null: List<Product>.from(json["products"]["data"].map((x) => Product.fromJson(x))),
    status: isBlankData(json["status"]),
    title:json["title"]==null?null: List<String>.from(json["title"].map((x) => x == null ? null : x)),
    orderingSection: isBlankData(json["ordering_section"]),
    sectionType: isBlankData(json["section_type"]),
    brands:json["brands"]==null?null: List<AllBrand>.from(json["brands"].map((x) => AllBrand.fromJson(x))),
    shop: json["shop"]==null?null:List<Shop>.from(json["shop"].map((x) => Shop.fromJson(x))),
    categories: json["categories"]==null?null:List<AllBrand>.from(json["categories"].map((x) => AllBrand.fromJson(x))),
    banner1: json["banner1"]==null?null:Banner.fromJson(json["banner1"]),
    banner2: json["banner2"]==null?null:Banner.fromJson(json["banner2"]),
    banner3: json["banner3"]==null?null:Banner.fromJson(json["banner3"]),
    banner4: json["banner4"]==null?null:Banner.fromJson(json["banner4"]),
    banner5: json["banner5"]==null?null:Banner.fromJson(json["banner5"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId == null ? null : categoryId,
    "category_layout": categoryLayout == null ? null : categoryLayout,
    "products": products,
    "status": status,
    "title": List<dynamic>.from(title.map((x) => x == null ? null : x)),
    "ordering_section": orderingSection,
    "section_type": sectionType,
    "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
    "shop": List<dynamic>.from(shop.map((x) => x.toJson())),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "banner1": banner1.toJson(),
    "banner2": banner2.toJson(),
    "banner3": banner3.toJson(),
    "banner4": banner4.toJson(),
    "banner5": banner5.toJson(),
  };
}
class Shop {
  Shop({
    this.id,
    this.userId,
    this.name,
    this.state,
    this.logo,
  });
  var id;
  var userId;
  var name;
  var state;
  var logo;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    id: isBlankData(json["id"]),
    userId: isBlankData(json["userId"]),
    name: isBlankData(json["name"]),
    state: isBlankData(json["state"]),
    logo: isBlankData(json["logo"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "name": name,
    "state": state,
    "logo": logo,
  };
}
