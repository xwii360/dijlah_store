import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/banners.dart';
class AllCategory {
  AllCategory({
    this.id,
    this.arName,
    this.name,
    this.enName,
    this.kuName,
    this.banner,
    this.brands,
    this.subCategories,
    this.banners,
    this.icon,
    this.numberOfChildren,
    this.categoryId,
    this.status,
  });
  var id;
  var name;
  var arName;
  var enName;
  var kuName;
  var banner;
  var brands;
  BannersAr subCategories;
  List<Banners> banners;
  var icon;
  var numberOfChildren;
  var categoryId;
  var status;

  factory AllCategory.fromJson(Map<String, dynamic> json) => AllCategory(
    id: isBlankData(json["id"]),
    name: isBlankData(json["name"]),
    arName: isBlankData(json["ar_name"]),
    enName: isBlankData(json["en_name"]),
    kuName: isBlankData(json["ku_name"]),
    banner: isBlankData(json["banner"]),
    brands: json["brands"]==null?null:List<dynamic>.from(json["brands"].map((x) => x)),
    subCategories: json["subCategories"]==null?null:BannersAr.fromJson(json["subCategories"]),
    banners: json["banners"]==null?null:List<Banners>.from(json["banners"]["data"].map((x) => Banners.fromJson(x))),
    icon: isBlankData(json["icon"]),
    numberOfChildren: isBlankData(json["number_of_children"]),
    categoryId: isBlankData(json["category_id"]),
    status: isBlankData( json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ar_name": arName == null ? null : arName,
    "en_name": enName == null ? null : enName,
    "banner": banner == null ? null : banner,
    "brands": brands == null ? null : List<dynamic>.from(brands.map((x) => x)),
    "subCategories": subCategories == null ? null : subCategories.toJson(),
    "banners": banners,
    "icon": icon == null ? null : icon,
    "number_of_children": numberOfChildren == null ? null : numberOfChildren,
    "category_id": categoryId == null ? null : categoryId,
    "status": status == null ? null : status,
  };
}

class BannersAr {
  BannersAr({
    this.data,
  });

  List<AllCategory> data;

  factory BannersAr.fromJson(Map<String, dynamic> json) => BannersAr(
    data: List<AllCategory>.from(json["data"].map((x) => AllCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
