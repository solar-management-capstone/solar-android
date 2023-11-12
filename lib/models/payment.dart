import 'package:mobile_solar_mp/models/account.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';

class Payment {
  String? paymentId;
  double? amount;
  String? constructionContractId;
  String? status;
  // Null? taxVnpay;
  // Null? payDateVnpay;
  // Null? payDate;
  String? createAt;
  bool? isDeposit;
  String? accountId;
  Account? account;
  ConstructionContract? constructionContract;

  Payment({
    this.paymentId,
    this.amount,
    this.constructionContractId,
    this.status,
    // this.taxVnpay,
    // this.payDateVnpay,
    // this.payDate,
    this.createAt,
    this.isDeposit,
    this.accountId,
    this.account,
    this.constructionContract,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    amount = json['amount'];
    constructionContractId = json['constructionContractId'];
    status = json['status'];
    // taxVnpay = json['taxVnpay'];
    // payDateVnpay = json['payDateVnpay'];
    // payDate = json['payDate'];
    createAt = json['createAt'];
    isDeposit = json['isDeposit'];
    accountId = json['accountId'];
    account =
        json['account'] != null ? Account?.fromJson(json['account']) : null;
    constructionContract = json['constructionContract'] != null
        ? ConstructionContract.fromJson(json['constructionContract'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentId'] = paymentId;
    data['amount'] = amount;
    data['constructionContractId'] = constructionContractId;
    data['status'] = status;
    // data['taxVnpay'] = taxVnpay;
    // data['payDateVnpay'] = payDateVnpay;
    // data['payDate'] = payDate;
    data['createAt'] = createAt;
    data['isDeposit'] = isDeposit;
    data['accountId'] = accountId;
    data['account'] = account?.toJson();
    data['constructionContract'] = constructionContract?.toJson();
    return data;
  }
}
