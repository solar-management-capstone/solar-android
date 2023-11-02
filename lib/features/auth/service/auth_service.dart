import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/http/http_client.dart';
import 'package:mobile_solar_mp/config/providers/user_provider.dart';
import 'package:mobile_solar_mp/constants/error_handling.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';
import 'package:provider/provider.dart';

class UserSignUp {
  final String username;
  final String phone;
  final String password;
  final String firstname;
  final String lastname;
  final String address;
  final bool gender;
  final String roleId;

  UserSignUp({
    required this.username,
    required this.phone,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.address,
    required this.gender,
    this.roleId = '4',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'phone': phone,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'address': address,
      'gender': gender,
      'roleId': roleId,
    };
  }

  factory UserSignUp.fromMap(Map<String, dynamic> map) {
    return UserSignUp(
      username: map['username'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      address: map['address'] as String,
      gender: map['gender'] as bool,
      roleId: map['roleId'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}

class AuthService {
  Future<void> signUpUser({
    required BuildContext context,
    required UserSignUp userSignUp,
  }) async {
    final response = await HttpClient.http
        .post(Uri.parse('$uri/Account/register'), body: userSignUp.toJson());

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          await SharedPreferencesUtils.setPhoneNumber(userSignUp.phone);
          if (context.mounted) {
            showSnackBar(context, 'Tạo tài khoản thành công');
          }
        },
      );
    }
  }

  Future<void> signInUser({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    final response = await HttpClient.http.post(
      Uri.parse('$uri/Token/Login_username_password'),
      body: json.encode({'username': username, 'password': password}),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          showSnackBar(context, 'Đăng nhập thành công');

          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final parseBodyToObject =
              json.decode(response.body); // convert String to Map
          userProvider.setUser(json.encode(parseBodyToObject['user']));

          final fullName = parseBodyToObject['user']['firstname'] +
              ' ' +
              parseBodyToObject['user']['lastname'];
          await SharedPreferencesUtils.setName(fullName);
          await SharedPreferencesUtils.setUser(
              json.encode(parseBodyToObject['user']));
          await SharedPreferencesUtils.setId(
              parseBodyToObject['user']['accountId']);
          await SharedPreferencesUtils.setAccessToken(
              parseBodyToObject['token']);
        },
      );
    }
  }
}
