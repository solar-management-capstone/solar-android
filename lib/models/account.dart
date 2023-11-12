import 'package:mobile_solar_mp/models/feedback.dart';

class Account {
  String? accountId;
  String? username;
  String? password;
  String? email;
  String? firstname;
  String? lastname;
  String? phone;
  bool? status;
  String? address;
  String? roleId;
  String? createAt;
  bool? gender;
  bool? isGoogleProvider;
  // Null? isLeader;
  // Null? isFree;
  // Null? role;
  // List<Null>? constructionContractCustomer;
  // List<Null>? constructionContractStaff;
  List<Feedback>? feedback;
  // List<Null>? paymentProcess;
  // List<Null>? requestAccount;
  // List<Null>? requestStaff;
  // List<Null>? survey;
  // List<Null>? teamStaff;
  // List<Null>? teamStaffLead;
  // List<Null>? warrantyReport;

  Account({
    this.accountId,
    this.username,
    this.password,
    this.email,
    this.firstname,
    this.lastname,
    this.phone,
    this.status,
    this.address,
    this.roleId,
    this.createAt,
    this.gender,
    this.isGoogleProvider,
    // this.isLeader,
    // this.isFree,
    // this.role,
    // this.constructionContractCustomer,
    // this.constructionContractStaff,
    this.feedback,
    // this.paymentProcess,
    // this.requestAccount,
    // this.requestStaff,
    // this.survey,
    // this.teamStaff,
    // this.teamStaffLead,
    // this.warrantyReport,
  });

  Account.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    status = json['status'];
    address = json['address'];
    roleId = json['roleId'];
    createAt = json['createAt'];
    gender = json['gender'];
    isGoogleProvider = json['isGoogleProvider'];
    // isLeader = json['isLeader'];
    // isFree = json['isFree'];
    // role = json['role'];
    // if (json['constructionContractCustomer'] != null) {
    //   constructionContractCustomer = <Null>[];
    //   json['constructionContractCustomer'].forEach((v) {
    //     constructionContractCustomer!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['constructionContractStaff'] != null) {
    //   constructionContractStaff = <Null>[];
    //   json['constructionContractStaff'].forEach((v) {
    //     constructionContractStaff!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['feedback'] != null) {
      feedback = <Feedback>[];
      json['feedback'].forEach((v) {
        feedback!.add(Feedback.fromJson(v));
      });
    }
    // if (json['paymentProcess'] != null) {
    //   paymentProcess = <Null>[];
    //   json['paymentProcess'].forEach((v) {
    //     paymentProcess!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['requestAccount'] != null) {
    //   requestAccount = <Null>[];
    //   json['requestAccount'].forEach((v) {
    //     requestAccount!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['requestStaff'] != null) {
    //   requestStaff = <Null>[];
    //   json['requestStaff'].forEach((v) {
    //     requestStaff!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['survey'] != null) {
    //   survey = <Null>[];
    //   json['survey'].forEach((v) {
    //     survey!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['teamStaff'] != null) {
    //   teamStaff = <Null>[];
    //   json['teamStaff'].forEach((v) {
    //     teamStaff!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['teamStaffLead'] != null) {
    //   teamStaffLead = <Null>[];
    //   json['teamStaffLead'].forEach((v) {
    //     teamStaffLead!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['warrantyReport'] != null) {
    //   warrantyReport = <Null>[];
    //   json['warrantyReport'].forEach((v) {
    //     warrantyReport!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['phone'] = phone;
    data['status'] = status;
    data['address'] = address;
    data['roleId'] = roleId;
    data['createAt'] = createAt;
    data['gender'] = gender;
    data['isGoogleProvider'] = isGoogleProvider;
    // data['isLeader'] = this.isLeader;
    // data['isFree'] = this.isFree;
    // data['role'] = this.role;
    // if (this.constructionContractCustomer != null) {
    //   data['constructionContractCustomer'] =
    //       this.constructionContractCustomer!.map((v) => v.toJson()).toList();
    // }
    // if (this.constructionContractStaff != null) {
    //   data['constructionContractStaff'] =
    //       this.constructionContractStaff!.map((v) => v.toJson()).toList();
    // }
    if (feedback != null) {
      data['feedback'] = feedback?.map((v) => v.toJson()).toList();
    }
    // if (this.paymentProcess != null) {
    //   data['paymentProcess'] =
    //       this.paymentProcess!.map((v) => v.toJson()).toList();
    // }
    // if (this.requestAccount != null) {
    //   data['requestAccount'] =
    //       this.requestAccount!.map((v) => v.toJson()).toList();
    // }
    // if (this.requestStaff != null) {
    //   data['requestStaff'] = this.requestStaff!.map((v) => v.toJson()).toList();
    // }
    // if (this.survey != null) {
    //   data['survey'] = this.survey!.map((v) => v.toJson()).toList();
    // }
    // if (this.teamStaff != null) {
    //   data['teamStaff'] = this.teamStaff!.map((v) => v.toJson()).toList();
    // }
    // if (this.teamStaffLead != null) {
    //   data['teamStaffLead'] =
    //       this.teamStaffLead!.map((v) => v.toJson()).toList();
    // }
    // if (this.warrantyReport != null) {
    //   data['warrantyReport'] =
    //       this.warrantyReport!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
