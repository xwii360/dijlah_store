import 'package:dijlah_store_ibtechiq/common/constant.dart';

class Attribute {
  Attribute({
    this.id,
    this.title,
    this.arTitle,
    this.enTitle,
    this.kuTitle,
    this.values,
  });
  var id;
  var title;
  var arTitle;
  var enTitle;
  var kuTitle;
  var values;
  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: isBlankData(json["id"]),
    title: isBlankData(json["title"]),
    arTitle: isBlankData(json["ar_title"]),
    kuTitle: isBlankData(json["ku_title"]),
    enTitle: isBlankData(json["en_title"]),
    values: json["values"] == null ? null :List<String>.from(json["values"].map((x) => x)),
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "ar_title": arTitle == null ? null : arTitle,
    "en_title": enTitle,
    "ku_title": kuTitle,
    "values": List<dynamic>.from(values.map((x) => x)),
  };
}
