import 'package:mobile_solar_mp/models/product.dart';

class PackageProduct {
  PackageProduct({
    this.productId,
    this.packageId,
    this.status,
    this.quantity,
    this.product,
  });
  String? productId;
  String? packageId;
  bool? status;
  int? quantity;
  Product? product;

  PackageProduct.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    packageId = json['packageId'];
    status = json['status'];
    quantity = json['quantity'];
    product = Product.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['productId'] = productId;
    data['packageId'] = packageId;
    data['status'] = status;
    data['quantity'] = quantity;
    data['product'] = product?.toJson();
    return data;
  }
}
