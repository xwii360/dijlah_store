import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';

class Banner {
  Banner({
    this.image,
    this.imageEn,
    this.imageKu,
    this.type,
    this.typeId,
    this.typeName,
    this.product,
  });

  var image;
  var imageEn;
  var imageKu;
  var type;
  var typeId;
  var typeName;
  var product;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    image: isBlankData(json["image"][0]),
    imageEn: isBlankData(json["image_en"][0]),
    imageKu: isBlankData(json["image_ku"][0]),
    type: isBlankData(json["type"]),
    typeId: isBlankData(json["type_id"]),
    typeName: isBlankData(json["type_name"]),
    product:json["product"]==null?null:Product.fromJson(json["product"]['data'][0]),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "image_en": imageEn,
    "image_ku": imageKu,
    "type": type,
    "type_id": typeId,
    "type_name": typeName,
    "product": product,
  };
}