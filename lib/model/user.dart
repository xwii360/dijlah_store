import 'package:dijlah_store_ibtechiq/common/constant.dart';

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.avatarOriginal,
    this.shopName,
    this.shopLogo,
    this.shopLink,
  });

  int id;
  String name;
  String email;
  dynamic avatar;
  String avatarOriginal;
  String shopName;
  String shopLogo;
  String shopLink;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: isBlankData(json["id"]),
    name:isBlankData( json["name"]),
    email: isBlankData(json["email"]),
    avatar:isBlankData( json["avatar"]),
    avatarOriginal: isBlankData(json["avatar_original"]),
    shopName: isBlankData(json["shop_name"]),
    shopLogo:isBlankData( json["shop_logo"]),
    shopLink: isBlankData(json["shop_link"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email":email,
    "avatar": avatar,
    "avatar_original": avatarOriginal,
    "shop_name": shopName,
    "shop_logo": shopLogo,
    "shop_link": shopLink,
  };
}