import 'package:mobile_solar_mp/models/image.dart';

class Product {
  Product({
    this.productId,
    this.name,
    this.price,
    this.manufacturer,
    this.feature,
    this.warrantyDate,
    this.status,
    this.image,
    this.packageProduct,
    this.productWarrantyReport,
  });
  String? productId;
  String? name;
  double? price;
  String? manufacturer;
  String? feature;
  String? warrantyDate;
  bool? status;
  List<ImageModel>? image;
  List<dynamic>? packageProduct;
  List<dynamic>? productWarrantyReport;

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    price = json['price'];
    manufacturer = json['manufacturer'];
    feature = json['feature'];
    warrantyDate = json['warrantyDate'];
    status = json['status'];
    image =
        List.from(json['image']).map((e) => ImageModel.fromJson(e)).toList();
    packageProduct = List.castFrom<dynamic, dynamic>(json['packageProduct']);
    productWarrantyReport =
        List.castFrom<dynamic, dynamic>(json['productWarrantyReport']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['productId'] = productId;
    data['name'] = name;
    data['price'] = price;
    data['manufacturer'] = manufacturer;
    data['feature'] = feature;
    data['warrantyDate'] = warrantyDate;
    data['status'] = status;
    data['image'] = image?.map((e) => e.toJson()).toList();
    data['packageProduct'] = packageProduct;
    data['productWarrantyReport'] = productWarrantyReport;
    return data;
  }
}
