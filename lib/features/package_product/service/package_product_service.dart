import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/http/http_client.dart';
import 'package:mobile_solar_mp/constants/error_handling.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/models/feedback.dart' as feedback_model;
import 'package:mobile_solar_mp/models/package.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';

class PackageProductService {
  Future<Package> getPackageById({
    required BuildContext context,
    required String id,
  }) async {
    Package package = Package();

    final response = await HttpClient.http.get(
      Uri.parse('$uri/Package/get-id?id=$id'),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          package = Package.fromJson(json.decode(response.body)['data']);
        },
      );
    }
    return package;
  }

  Future<void> createRequest({
    required BuildContext context,
    required String packageId,
    required String description,
  }) async {
    final response = await HttpClient.http.post(
      Uri.parse('$uri/Request/Insert-request'),
      body: json.encode(
        {
          'packageId': packageId,
          'accountId': SharedPreferencesUtils.getId(),
          'description': description
        },
      ),
    );

    if (context.mounted) {
      httpErrorHandle(response: response, context: context, onSuccess: () {});
    }
  }

  Future<List<feedback_model.Feedback>> getFeedbacksByPackageId({
    required BuildContext context,
    required String packageId,
  }) async {
    List<feedback_model.Feedback> feedbacks = [];
    final response = await HttpClient.http.get(
      Uri.parse('$uri/Feedback/get-feedback-package?packageId=$packageId'),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = json.decode(response.body);
          for (var i = 0; i < data['data'].length; i++) {
            final entry = data['data'][i];
            feedback_model.Feedback package =
                feedback_model.Feedback.fromJson(entry);
            feedbacks.add(package);
          }
        },
      );
    }

    return feedbacks;
  }
}
