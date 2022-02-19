import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/order_history.dart';

class AllRefundHistory {
  AllRefundHistory({
    this.id,
    this.userId,
    this.orderId,
    this.orderDetailId,
    this.refundAmount,
    this.reason,
    this.refundStatus,
    this.rejectReason,
    this.createdAt,
    this.updatedAt,
    this.orderDetail,
  });
  var id;
  var userId;
  var orderId;
  var orderDetailId;
  var refundAmount;
  var reason;
  var refundStatus;
  var rejectReason;
  var createdAt;
  var updatedAt;
  List<AllOrderHistory> orderDetail;

  factory AllRefundHistory.fromJson(Map<String, dynamic> json) => AllRefundHistory(
    id:isBlankData( json["id"]),
    userId: isBlankData(json["user_id"]),
    orderId: isBlankData(json["order_id"]),
    orderDetailId:isBlankData( json["order_detail_id"]),
    refundAmount:isBlankData( json["refund_amount"]),
    reason:isBlankData( json["reason"]),
    refundStatus: isBlankData(json["refund_status"]),
    rejectReason:isBlankData( json["reject_reason"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    orderDetail:List<AllOrderHistory>.from(json["orderDetail"]["data"].map((x) => AllOrderHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "order_id": orderId,
    "order_detail_id": orderDetailId,
    "refund_amount": refundAmount,
    "reason": reason,
    "refund_status": refundStatus,
    "reject_reason": rejectReason,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "orderDetail": orderDetail,
  };
}
