import 'package:mobile_solar_mp/models/product.dart';
import 'package:mobile_solar_mp/models/bracket.dart';

class PackageProduct {
  PackageProduct({
    this.productId,
    this.packageId,
    this.status,
    this.quantity,
    this.product,
    this.bracket,
  });
  String? productId;
  String? packageId;
  bool? status;
  int? quantity;
  Product? product;
  Bracket? bracket;

  PackageProduct.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    packageId = json['packageId'];
    status = json['status'];
    quantity = json['quantity'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    bracket =
        json['bracket'] != null ? Bracket.fromJson(json['bracket']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['productId'] = productId;
    data['packageId'] = packageId;
    data['status'] = status;
    data['quantity'] = quantity;
    data['product'] = product?.toJson();
    data['bracket'] = bracket?.toJson();
    return data;
  }
}
