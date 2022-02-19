import 'package:dijlah_store_ibtechiq/common/constant.dart';

class AllOrderHistory {
  AllOrderHistory({
    this.id,
    this.code,
    this.user,
    this.shippingAddress,
    this.paymentType,
    this.paymentStatus,
    this.grandTotal,
    this.couponDiscount,
    this.shippingCost,
    this.subtotal,
    this.tax,
    this.date,
    this.notes
  });

  var id;
  var code;
  User user;
  ShippingAddress shippingAddress;
  var paymentType;
  var paymentStatus;
  var grandTotal;
  var couponDiscount;
  var shippingCost;
  var subtotal;
  var tax;
  var date;
  var  notes;

  factory AllOrderHistory.fromJson(Map<String, dynamic> json) => AllOrderHistory(
    id: isBlankData(json["id"]),
    code:isBlankData( json["code"]),
    user: User.fromJson(json["user"]),
    shippingAddress: ShippingAddress.fromJson(json["shipping_address"]),
    paymentType: isBlankData(json["payment_type"]),
    paymentStatus:isBlankData( json["payment_status"]),
    grandTotal:isBlankData( json["grand_total"]),
    couponDiscount: isBlankData(json["coupon_discount"]),
    shippingCost: isBlankData(json["shipping_cost"]),
    subtotal:isBlankData( json["subtotal"]),
    tax: isBlankData(json["tax"]),
    date:isBlankData( json["date"]),
    notes:isBlankData( json["notes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "user": user.toJson(),
    "shipping_address": shippingAddress.toJson(),
    "payment_type": paymentType,
    "payment_status": paymentStatus,
    "grand_total": grandTotal,
    "coupon_discount": couponDiscount,
    "shipping_cost": shippingCost,
    "subtotal": subtotal,
    "tax": tax,
    "date": date,
    "notes": notes,
  };
}

class ShippingAddress {
  ShippingAddress({
    this.name,
    this.email,
    this.address,
    this.country,
    this.city,
    this.postalCode,
    this.phone,
    this.checkoutType,
  });

  String name;
  String email;
  String address;
  String country;
  String city;
  String postalCode;
  String phone;
  String checkoutType;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    name: isBlankData(json["name"]),
    email:isBlankData( json["email"]),
    address: isBlankData(json["address"]),
    country: isBlankData(json["country"]),
    city: isBlankData(json["city"]),
    postalCode:isBlankData( json["postal_code"]),
    phone: isBlankData(json["phone"]),
    checkoutType:isBlankData( json["checkout_type"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "address": address,
    "country": country,
    "city": city,
    "postal_code": postalCode,
    "phone": phone,
    "checkout_type": checkoutType,
  };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.avatarOriginal,
  });

  int id;
  String name;
  String email;
  dynamic avatar;
  String avatarOriginal;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: isBlankData(json["id"]),
    name: isBlankData(json["name"]),
    email: isBlankData(json["email"]),
    avatar: isBlankData(json["avatar"]),
    avatarOriginal: isBlankData(json["avatar_original"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "avatar": avatar,
    "avatar_original": avatarOriginal,
  };
}
