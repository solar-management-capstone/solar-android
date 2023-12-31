import 'package:mobile_solar_mp/models/acceptance.dart';
import 'package:mobile_solar_mp/models/bracket.dart';
import 'package:mobile_solar_mp/models/feedback.dart';
import 'package:mobile_solar_mp/models/package.dart';
import 'package:mobile_solar_mp/models/payment_process.dart';
import 'package:mobile_solar_mp/models/staff.dart';

class ConstructionContract {
  String? constructioncontractId;
  String? status;
  String? startdate;
  String? enddate;
  double? totalcost;
  bool? isConfirmed;
  String? imageFile;
  String? customerId;
  String? staffid;
  String? packageId;
  String? bracketId;
  String? serveyId;
  Bracket? bracket;
  String? description;
  // Customer? customer;
  Package? package;
  Staff? staff;
  List<Acceptance>? acceptance;
  List<Feedback>? feedback;
  List<PaymentProcess>? paymentProcess;
  // List<Process>? process;
  // List<WarrantyReport>? warrantyReport;

  ConstructionContract({
    this.constructioncontractId,
    this.status,
    this.startdate,
    this.enddate,
    this.totalcost,
    this.isConfirmed,
    this.imageFile,
    this.customerId,
    this.staffid,
    this.packageId,
    this.bracketId,
    this.serveyId,
    this.bracket,
    this.description,
    // this.customer,
    this.package,
    this.staff,
    // this.acceptance,
    this.feedback,
    // this.paymentProcess,
    // this.process,
    // this.warrantyReport,
  });

  ConstructionContract.fromJson(Map<String, dynamic> json) {
    constructioncontractId = json['constructioncontractId'];
    status = json['status'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    totalcost = json['totalcost'];
    isConfirmed = json['isConfirmed'];
    imageFile = json['imageFile'];
    customerId = json['customerId'];
    staffid = json['staffid'];
    packageId = json['packageId'];
    bracketId = json['bracketId'];
    serveyId = json['serveyId'];
    bracket =
        json['bracket'] != null ? Bracket.fromJson(json['bracket']) : null;
    description = json['description'];
    // customer = json['customer'] != null
    //     ? new Customer.fromJson(json['customer'])
    //     : null;
    package =
        json['package'] != null ? Package.fromJson(json['package']) : null;
    staff = json['staff'] != null ? Staff.fromJson(json['staff']) : null;
    if (json['acceptance'] != null) {
      acceptance = <Acceptance>[];
      json['acceptance'].forEach((v) {
        acceptance!.add(Acceptance.fromJson(v));
      });
    }
    if (json['feedback'] != null) {
      feedback = <Feedback>[];
      json['feedback'].forEach((v) {
        feedback!.add(Feedback.fromJson(v));
      });
    }
    if (json['paymentProcess'] != null) {
      paymentProcess = <PaymentProcess>[];
      json['paymentProcess'].forEach((v) {
        paymentProcess!.add(PaymentProcess.fromJson(v));
      });
    }
    // if (json['process'] != null) {
    //   process = <Process>[];
    //   json['process'].forEach((v) {
    //     process!.add(new Process.fromJson(v));
    //   });
    // }
    // if (json['warrantyReport'] != null) {
    //   warrantyReport = <WarrantyReport>[];
    //   json['warrantyReport'].forEach((v) {
    //     warrantyReport!.add(new WarrantyReport.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['constructioncontractId'] = constructioncontractId;
    data['status'] = status;
    data['startdate'] = startdate;
    data['enddate'] = enddate;
    data['totalcost'] = totalcost;
    data['isConfirmed'] = isConfirmed;
    data['imageFile'] = imageFile;
    data['customerId'] = customerId;
    data['staffid'] = staffid;
    data['packageId'] = packageId;
    data['bracketId'] = bracketId;
    data['serveyId'] = serveyId;
    if (bracket != null) {
      data['bracket'] = bracket?.toJson();
    }
    data['description'] = description;
    // if (customer != null) {
    //   data['customer'] = customer!.toJson();
    // }
    if (package != null) {
      data['package'] = package?.toJson();
    }
    if (staff != null) {
      data['staff'] = staff?.toJson();
    }
    if (acceptance != null) {
      data['acceptance'] = acceptance?.map((v) => v.toJson()).toList();
    }
    if (feedback != null) {
      data['feedback'] = feedback?.map((v) => v.toJson()).toList();
    }
    if (paymentProcess != null) {
      data['paymentProcess'] = paymentProcess?.map((v) => v.toJson()).toList();
    }
    // if (process != null) {
    //   data['process'] = process!.map((v) => v.toJson()).toList();
    // }
    // if (warrantyReport != null) {
    //   data['warrantyReport'] =
    //       warrantyReport!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
