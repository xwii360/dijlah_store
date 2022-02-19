import 'package:dijlah_store_ibtechiq/common/constant.dart';

class FlashDealSliders {
  FlashDealSliders({
    this.id,
    this.arTitle,
    this.title,
    this.enTitle,
    this.kuTitle,
    this.date,
    this.banner,
    this.bgColor,
    this.textColor
  });

  var id;
  var arTitle;
  var title;
  var enTitle;
  var kuTitle;
  var date;
  var banner;
  var bgColor;
  var textColor;

  factory FlashDealSliders.fromJson(Map<String, dynamic> json) => FlashDealSliders(
    id: isBlankData(json["id"]),
    arTitle: isBlankData(json["ar_title"]),
    title: isBlankData(json["title"]),
    enTitle: isBlankData(json["en_title"]),
    kuTitle: isBlankData(json["ku_title"]),
    date: isBlankData(json["date"]),
    banner:isBlankData( json["banner"]),
    bgColor:isBlankData( json["bg_color"]),
    textColor:isBlankData( json["title_color"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "ar_title": arTitle,
    "en_title": enTitle,
    "ku_title": kuTitle,
    "date": date,
    "banner": banner,
  };
}
