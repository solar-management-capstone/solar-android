import 'package:mobile_solar_mp/models/account.dart';

class PaymentProcess {
  String? paymentId;
  double? amount;
  String? constructionContractId;
  String? status;
  String? taxVnpay;
  String? payDateVnpay;
  String? payDate;
  String? createAt;
  bool? isDeposit;
  String? accountId;
  Account? account;

  PaymentProcess({
    this.paymentId,
    this.amount,
    this.constructionContractId,
    this.status,
    this.taxVnpay,
    this.payDateVnpay,
    this.payDate,
    this.createAt,
    this.isDeposit,
    this.accountId,
    this.account,
  });

  PaymentProcess.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    amount = json['amount'];
    constructionContractId = json['constructionContractId'];
    status = json['status'];
    taxVnpay = json['taxVnpay'];
    payDateVnpay = json['payDateVnpay'];
    payDate = json['payDate'];
    createAt = json['createAt'];
    isDeposit = json['isDeposit'];
    accountId = json['accountId'];
    account =
        json['account'] != null ? Account.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentId'] = paymentId;
    data['amount'] = amount;
    data['constructionContractId'] = constructionContractId;
    data['status'] = status;
    data['taxVnpay'] = taxVnpay;
    data['payDateVnpay'] = payDateVnpay;
    data['payDate'] = payDate;
    data['createAt'] = createAt;
    data['isDeposit'] = isDeposit;
    data['accountId'] = accountId;
    if (account != null) {
      data['account'] = account?.toJson();
    }
    return data;
  }
}
