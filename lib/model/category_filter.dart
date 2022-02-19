import 'package:dijlah_store_ibtechiq/model/category.dart';
class CategoryFilter {
  CategoryFilter({
    this.data,
  });
  List<AllCategory> data;
  factory CategoryFilter.fromJson(Map<String, dynamic> json) => CategoryFilter(
    data: List<AllCategory>.from(json["data"].map((x) => AllCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

