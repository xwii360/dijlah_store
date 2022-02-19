import 'package:dijlah_store_ibtechiq/common/constant.dart';

class Reviews {
  Reviews({
    this.user,
    this.rating,
    this.comment,
    this.time,
  });

  User user;
  var rating;
  var comment;
  var time;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    user: User.fromJson(json["user"]),
    rating: isBlankData(json["rating"]),
    comment:isBlankData( json["comment"]),
    time:isBlankData( json["time"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "rating": rating,
    "comment": comment,
    "time": time,
  };
}

class User {
  User({
    this.name,
  });

  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
