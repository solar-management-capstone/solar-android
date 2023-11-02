import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/http/http_client.dart';
import 'package:mobile_solar_mp/config/providers/user_provider.dart';
import 'package:mobile_solar_mp/constants/error_handling.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/models/user.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';
import 'package:provider/provider.dart';

class EditProfileService {
  Future<User> getUser() async {
    final accountId = SharedPreferencesUtils.getId();
    final response = await HttpClient.http
        .get(Uri.parse('$uri/Account/get-id?id=$accountId'));

    final parseBodyToObject = json.decode(response.body);
    User user = User.fromMap(parseBodyToObject['data']);
    return user;
  }

  Future<void> updateUser({
    required BuildContext context,
    required String accountId,
    required String firstname,
    required String lastname,
    required String address,
    required bool gender,
  }) async {
    User user = User(
      accountId: accountId,
      firstname: firstname,
      lastname: lastname,
      address: address,
      gender: gender,
    );
    final response = await HttpClient.http
        .put(Uri.parse('$uri/Account/update-Account'), body: user.toJson());

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final parseBodyToObject =
              json.decode(response.body); // convert String to Map
          userProvider.setUser(json.encode(parseBodyToObject['data']));

          await SharedPreferencesUtils.setUser(
              json.encode(parseBodyToObject['data']));
        },
      );
    }
  }
}
