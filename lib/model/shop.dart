import 'package:dijlah_store_ibtechiq/common/constant.dart';

class AllShop {
  AllShop({
    this.id,
    this.userId,
    this.name,
    this.user,
    this.logo,
    this.sliders,
    this.address,
    this.facebook,
    this.google,
    this.twitter,
    this.youtube,
    this.instagram,
  });

  var id;
  var userId;
  var name;
  User user;
  var logo;
  var sliders;
  var address;
  var facebook;
  var google;
  var twitter;
  var youtube;
  var instagram;

  factory AllShop.fromJson(Map<String, dynamic> json) => AllShop(
    id: isBlankData(json["id"]),
    userId: isBlankData(json["user_id"]),
    name: isBlankData( json["name"]),
    user: User.fromJson(json["user"]),
    logo:isBlankData( json["logo"]),
    sliders:List<String>.from(json["sliders"].map((x) => x)),
    address: isBlankData(json["address"]),
    facebook: isBlankData(json["facebook"]),
    google: isBlankData(json["google"]),
    twitter: isBlankData( json["twitter"]),
    youtube:isBlankData(json["youtube"]),
    instagram:isBlankData( json["instagram"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name == null ? null : name,
    "user": user.toJson(),
    "logo": logo,
    "sliders": List<dynamic>.from(sliders.map((x) => x)),
    "address": address == null ? null : address,
    "facebook": facebook == null ? null : facebook,
    "google": google == null ? null : google,
    "twitter": twitter == null ? null : twitter,
    "youtube": youtube == null ? null : youtube,
    "instagram": instagram,
  };
}

class User {
  User({
    this.name,
    this.email,
    this.avatar,
    this.avatarOriginal,
  });

  String name;
  String email;
  dynamic avatar;
  String avatarOriginal;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name:isBlankData( json["name"]),
    email: isBlankData(json["email"]),
    avatar: isBlankData(json["avatar"]),
    avatarOriginal:isBlankData(json["avatar_original"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "avatar": avatar,
    "avatar_original": avatarOriginal == null ? null : avatarOriginal,
  };
}
