import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';

class WishLists {
  WishLists({
    this.id,
    this.product,
    this.isLoadingDelete
  });

  var id;
  Product product;
  var isLoadingDelete;

  factory WishLists.fromJson(Map<String, dynamic> json) => WishLists(
    id:isBlankData( json["id"]),
    product: json["product"]==null?null:Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product.toJson(),
  };
}
