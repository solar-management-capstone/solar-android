import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static late SharedPreferences _prefsInstance;

  static Future<SharedPreferences> init() async {
    return _prefsInstance = await SharedPreferences.getInstance();
  }

  static Future<bool> setId(String id) async {
    return await _prefsInstance.setString('id', id);
  }

  static String? getId() {
    return _prefsInstance.getString('id');
  }

  static Future<bool> setName(String name) async {
    return await _prefsInstance.setString('name', name);
  }

  static String? getName() {
    return _prefsInstance.getString('name');
  }

  static Future<bool> setAccessToken(String accessToken) async {
    return await _prefsInstance.setString('accessToken', accessToken);
  }

  static String? getAccessToken() {
    return _prefsInstance.getString('accessToken');
  }

  static Future<bool> setUser(String user) async {
    return await _prefsInstance.setString('user', user);
  }

  static String? getUser() {
    return _prefsInstance.getString('user');
  }

  static Future<bool> setPhoneNumber(String phoneNumber) async {
    return await _prefsInstance.setString('phoneNumber', phoneNumber);
  }

  static String? getPhoneNumber() {
    return _prefsInstance.getString('phoneNumber');
  }

  static Future<bool> clearStorage() async {
    return await _prefsInstance.clear();
  }
}
