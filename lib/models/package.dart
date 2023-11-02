import 'package:mobile_solar_mp/models/promotion.dart';
import 'package:mobile_solar_mp/models/package_product.dart';

class Package {
  Package({
    this.packageId,
    this.name,
    this.description,
    this.price,
    this.promotionPrice,
    this.roofArea,
    this.electricBill,
    this.promotionId,
    this.status,
    this.packageProduct,
    this.promotion,
  });
  String? packageId;
  String? name;
  String? description;
  double? price;
  int? roofArea;
  double? electricBill;
  double? promotionPrice;
  String? promotionId;
  bool? status;
  List<PackageProduct>? packageProduct;
  Promotion? promotion;

  Package.fromJson(Map<String, dynamic> json) {
    packageId = json['packageId'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    promotionPrice = json['promotionPrice'];
    electricBill = json['electricBill'];
    roofArea = json['roofArea'];
    promotionId = json['promotionId'];
    status = json['status'];
    packageProduct = List.from(json['packageProduct'])
        .map((e) => PackageProduct.fromJson(e))
        .toList();
    if (json['promotion'] != null) {
      promotion = Promotion?.fromJson(json['promotion']);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['packageId'] = packageId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['promotionPrice'] = promotionPrice;
    data['electricBill'] = electricBill;
    data['roofArea'] = roofArea;
    data['promotionId'] = promotionId;
    data['status'] = status;
    data['packageProduct'] = packageProduct?.map((e) => e.toJson()).toList();
    if (promotion != null) {
      data['promotion'] = promotion?.toJson();
    }
    return data;
  }
}
