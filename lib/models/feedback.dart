import 'package:mobile_solar_mp/models/account.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';
import 'package:mobile_solar_mp/models/package.dart';

class Feedback {
  String? feedbackId;
  String? description;
  String? createAt;
  bool? status;
  int? rating;
  String? contructionContractId;
  String? accountId;
  String? image;
  String? packageId;
  Account? account;
  ConstructionContract? contructionContract;
  Package? package;

  Feedback({
    this.feedbackId,
    this.description,
    this.createAt,
    this.status,
    this.rating,
    this.contructionContractId,
    this.accountId,
    this.image,
    this.packageId,
    this.account,
    this.contructionContract,
    this.package,
  });

  Feedback.fromJson(Map<String, dynamic> json) {
    feedbackId = json['feedbackId'];
    description = json['description'];
    createAt = json['createAt'];
    status = json['status'];
    rating = json['rating'];
    contructionContractId = json['contructionContractId'];
    accountId = json['accountId'];
    image = json['image'];
    packageId = json['packageId'];
    contructionContract = json['contructionContract'] != null
        ? ConstructionContract?.fromJson(json['contructionContract'])
        : null;
    account =
        json['account'] != null ? Account?.fromJson(json['account']) : null;
    package =
        json['package'] != null ? Package?.fromJson(json['package']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feedbackId'] = feedbackId;
    data['description'] = description;
    data['createAt'] = createAt;
    data['status'] = status;
    data['rating'] = rating;
    data['contructionContractId'] = contructionContractId;
    data['accountId'] = accountId;
    data['image'] = image;
    data['packageId'] = packageId;
    if (account != null) {
      data['account'] = account?.toJson();
    }
    if (contructionContract != null) {
      data['contructionContract'] = contructionContract?.toJson();
    }
    if (package != null) {
      data['package'] = package?.toJson();
    }
    return data;
  }
}
