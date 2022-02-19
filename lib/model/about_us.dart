import 'package:dijlah_store_ibtechiq/common/constant.dart';

class AboutUsAndPrivacy {
  AboutUsAndPrivacy({
    this.id,
    this.aboutUsAr,
    this.aboutUsEn,
    this.aboutUsKu,
    this.privacyAr,
    this.privacyEn,
    this.privacyKu,
  });

  int id;
  String aboutUsAr;
  String aboutUsEn;
  String aboutUsKu;
  String privacyAr;
  String privacyEn;
  String privacyKu;

  factory AboutUsAndPrivacy.fromJson(Map<String, dynamic> json) => AboutUsAndPrivacy(
    id: isBlankData(json["id"]),
    aboutUsAr: isBlankData(json["about_us_ar"]),
    aboutUsEn: isBlankData(json["about_us_en"]),
    aboutUsKu: isBlankData(json["about_us_ku"]),
    privacyAr: isBlankData(json["privacy_ar"]),
    privacyEn: isBlankData(json["privacy_en"]),
    privacyKu: isBlankData(json["privacy_ku"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "about_us_ar": aboutUsAr,
    "about_us_en": aboutUsEn,
    "about_us_ku": aboutUsKu,
    "privacy_ar": privacyAr,
    "privacy_en": privacyEn,
    "privacy_ku": privacyKu,
  };
}
