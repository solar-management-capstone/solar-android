import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/http/http_client.dart';
import 'package:mobile_solar_mp/constants/error_handling.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';

class ChangePasswordService {
  Future<void> changePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
  }) async {
    String accountId = SharedPreferencesUtils.getId()!;
    final response = await HttpClient.http.put(
      Uri.parse('$uri/Account/ChangePass'),
      body: json.encode(
        {
          'oldPass': oldPassword,
          'newPass': newPassword,
          'accountId': accountId
        },
      ),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {},
      );
    }
  }
}
