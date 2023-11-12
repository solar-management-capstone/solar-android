import 'dart:convert';

class FilterPackage {
  final double? roofArea;
  final double? electricBill;

  FilterPackage({this.roofArea, this.electricBill});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roofArea': roofArea,
      'electricBill': electricBill,
    };
  }

  factory FilterPackage.fromMap(Map<String, dynamic> map) {
    return FilterPackage(
      roofArea: map['roofArea'] != null ? map['roofArea'] as double : null,
      electricBill:
          map['electricBill'] != null ? map['electricBill'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterPackage.fromJson(String source) =>
      FilterPackage.fromMap(json.decode(source) as Map<String, dynamic>);
}
