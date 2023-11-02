import 'package:mobile_solar_mp/models/package.dart';

class Promotion {
  String? promotionId;
  double? amount;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? createAt;
  bool? status;
  List<Package>? package;

  Promotion({
    this.promotionId,
    this.amount,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.createAt,
    this.status,
    this.package,
  });

  Promotion.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
    amount = json['amount'];
    title = json['title'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createAt = json['createAt'];
    status = json['status'];
    if (json['package'] != null) {
      package = <Package>[];
      json['package'].forEach((v) {
        package!.add(Package.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotionId'] = promotionId;
    data['amount'] = amount;
    data['title'] = title;
    data['description'] = description;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['createAt'] = createAt;
    data['status'] = status;
    if (package != null) {
      data['package'] = package!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
