import 'package:dijlah_store_ibtechiq/common/constant.dart';

class OrderDetail {
  OrderDetail({
    this.id,
    this.productId,
    this.productThumbnailImage,
    this.variation,
    this.price,
    this.tax,
    this.shippingCost,
    this.couponDiscount,
    this.quantity,
    this.paymentStatus,
    this.deliveryStatus,
    this.enName,
    this.kuName,
    this.arName,
    this.name,
    this.refundable
  });

  var id;
  var productId;
  var arName;
  var name;
  var kuName;
  var enName;
  var productThumbnailImage;
  var variation;
  var price;
  var tax;
  var shippingCost;
  var couponDiscount;
  var quantity;
  var paymentStatus;
  var deliveryStatus;
  var refundable;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: isBlankData(json["id"]),
    productId: isBlankData(json["product_id"]),
    name: isBlankData(json["product_name"]),
    arName:isBlankData( json["product_name_ar"]),
    enName: isBlankData(json["product_name_en"]),
    kuName: isBlankData(json["product_name_ku"]),
    productThumbnailImage: isBlankData(json["product_thumbnail_image"]),
    variation: isBlankData(json["variation"]),
    price: isBlankData(json["price"]),
    tax: isBlankData(json["tax"]),
    shippingCost: isBlankData(json["shipping_cost"]),
    couponDiscount: isBlankData(json["coupon_discount"]),
    quantity: isBlankData(json["quantity"]),
    paymentStatus: isBlankData(json["payment_status"]),
    deliveryStatus: isBlankData(json["delivery_status"]),
    refundable: json["refundable"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "product_name": name,
    "product_name_ar": arName,
    "product_name_en": enName,
    "product_name_ku": kuName,
    "product_thumbnail_image": productThumbnailImage,
    "variation": variation,
    "price": price,
    "tax": tax,
    "shipping_cost": shippingCost,
    "coupon_discount": couponDiscount,
    "quantity": quantity,
    "payment_status": paymentStatus,
    "delivery_status": deliveryStatus,
  };
}
