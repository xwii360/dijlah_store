import 'package:dijlah_store_ibtechiq/common/constant.dart';

class CheckWishList {
  CheckWishList({
    this.message,
    this.isInWishlist,
    this.productId,
    this.wishlistId,
  });
  var message;
  var isInWishlist;
  var productId;
  var wishlistId;
  factory CheckWishList.fromJson(Map<String, dynamic> json) => CheckWishList(
    message: isBlankData(json["message"]),
    isInWishlist: isBlankData(json["is_in_wishlist"]),
    productId: isBlankData(json["product_id"]),
    wishlistId:isBlankData( json["wishlist_id"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "is_in_wishlist": isInWishlist,
    "product_id": productId,
    "wishlist_id": wishlistId,
  };
}
