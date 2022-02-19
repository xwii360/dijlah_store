import 'package:dijlah_store_ibtechiq/model/all_brands.dart';
class CategoryBrands {
  CategoryBrands({
    this.data,
  });
  List<AllBrand> data;
  factory CategoryBrands.fromJson(Map<String, dynamic> json) => CategoryBrands(
    data: List<AllBrand>.from(json["data"].map((x) => AllBrand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

