import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/models/filter_package.dart';

class FilterPackageProvider extends ChangeNotifier {
  FilterPackage _filterPackage = FilterPackage();

  FilterPackage get filterPackage => _filterPackage;

  void setFilterPackage(FilterPackage filterPackage) {
    _filterPackage = filterPackage;
    notifyListeners();
  }
}
