import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
class CartItem {
    CartItem({
        this.id,
        this.ownerId,
        this.product,
        this.variation,
        this.price,
        this.tax,
        this.shippingCost,
        this.quantity,
        this.date,
        this.isLoadingDelete,
        this.isLoadingQuantity
    });
    var id;
    var ownerId;
    Product product;
    var variation;
    var price;
    var tax;
    var shippingCost;
    var quantity;
    var date;
    var isLoadingQuantity;
    var isLoadingDelete;
    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: isBlankData(json["id"]),
        ownerId: isBlankData(json["owner_id"]),
        product: json["product"]==null?null:Product.fromJson(json["product"]),
        variation: isBlankData(json["variation"]),
        price: isBlankData(json["price"]),
        tax: isBlankData(json["tax"]),
        shippingCost:isBlankData( json["shipping_cost"]),
        quantity: isBlankData( json["quantity"]),
        date: isBlankData(json["date"]),
    );
    Map<String, dynamic> toJson() => {
        "id": id,
        "owner_id": ownerId,
        "product": product.toJson(),
        "variation": variation,
        "price": price,
        "tax": tax,
        "shipping_cost": shippingCost,
        "quantity": quantity,
        "date": date,
    };
}