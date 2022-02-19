import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/all_brands.dart';

class CustomPage {
  CustomPage({
    this.id,
    this.title,
    this.icon,
    this.categoryId,
    this.brands,
    this.status,
  });
  var id;
  var title;
  var icon;
  var categoryId;
  List<AllBrand> brands;
  var status;

  factory CustomPage.fromJson(Map<String, dynamic> json) => CustomPage(
    id: isBlankData(json["id"]),
    title: json["title"]==null?null:List<String>.from(json["title"].map((x) => x)),
    icon:isBlankData( json["icon"]),
    categoryId:isBlankData( json["category_id"]),
    brands: json["brands"]==null?null:List<AllBrand>.from(json["brands"].map((x) => AllBrand.fromJson(x))),
    status: isBlankData(json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "icon": icon,
    "category_id": categoryId,
    "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
    "status": status,
  };
}
