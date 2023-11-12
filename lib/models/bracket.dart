import 'package:mobile_solar_mp/models/construction_contract.dart';
import 'package:mobile_solar_mp/models/image.dart';

class Bracket {
  String? bracketId;
  String? name;
  double? price;
  String? manufacturer;
  bool? status;
  List<ConstructionContract>? constructionContract;
  List<ImageModel>? image;

  Bracket({
    this.bracketId,
    this.name,
    this.price,
    this.manufacturer,
    this.status,
    this.constructionContract,
    this.image,
  });

  Bracket.fromJson(Map<String, dynamic> json) {
    bracketId = json['bracketId'];
    name = json['name'];
    price = json['price'];
    manufacturer = json['manufacturer'];
    status = json['status'];
    if (json['constructionContract'] != null) {
      constructionContract = <ConstructionContract>[];
      json['constructionContract']?.forEach((v) {
        constructionContract!.add(ConstructionContract.fromJson(v));
      });
    }
    if (json['image'] != null) {
      image = <ImageModel>[];
      json['image']?.forEach((v) {
        image!.add(ImageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bracketId'] = bracketId;
    data['name'] = name;
    data['price'] = price;
    data['manufacturer'] = manufacturer;
    data['status'] = status;
    if (constructionContract != null) {
      data['constructionContract'] =
          constructionContract!.map((v) => v.toJson()).toList();
    }
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
