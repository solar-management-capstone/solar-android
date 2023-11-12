import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/models/account.dart';

class UserProvider extends ChangeNotifier {
  Account _user = Account();

  Account get user => _user;

  void setUser(Map<String, dynamic> user) {
    _user = Account.fromJson(user);
    notifyListeners();
  }
}
