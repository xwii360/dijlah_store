import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/banner.dart';

class Banners {
  Banners({
    this.id,
    this.status,
    this.banner1,
    this.banner2,
    this.banner3,
    this.banner4,
    this.banner5,
  });
  var id;
  int status;
  Banner banner1;
  Banner banner2;
  Banner banner3;
  Banner banner4;
  Banner banner5;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    id: isBlankData(json["id"]),
    status:isBlankData( json["status"]),
    banner1:json["banner1"]==null?null: Banner.fromJson(json["banner1"]),
    banner2:json["banner2"]==null?null: Banner.fromJson(json["banner2"]),
    banner3: json["banner3"]==null?null:Banner.fromJson(json["banner3"]),
    banner4:json["banner4"]==null?null: Banner.fromJson(json["banner4"]),
    banner5: json["banner5"]==null?null:Banner.fromJson(json["banner5"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "banner1": banner1.toJson(),
    "banner2": banner2.toJson(),
    "banner3": banner3.toJson(),
    "banner4": banner4.toJson(),
    "banner5": banner5.toJson(),
  };
}


