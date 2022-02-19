import 'package:dijlah_store_ibtechiq/common/constant.dart';

class AllBrand {
  AllBrand({
    this.id,
    this.name,
    this.arName,
    this.enName,
    this.kuName,
    this.logo,
  });
  var id;
  var name;
  var arName;
  var enName;
  var kuName;
  var logo;
  factory AllBrand.fromJson(Map<String, dynamic> json) => AllBrand(
    id: isBlankData(json["id"]),
    name: isBlankData(json["name"]),
    arName: isBlankData(json["ar_name"]),
    enName: isBlankData( json["en_name"]),
    kuName: isBlankData( json["ku_name"]),
    logo: isBlankData(json["logo"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ar_name": arName,
    "en_name": enName == null ? null : enName,
    "ku_name": kuName == null ? null : kuName,
    "logo": logo,
  };
}
