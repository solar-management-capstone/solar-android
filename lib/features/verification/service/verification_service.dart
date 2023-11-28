import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/http/http_client.dart';
import 'package:mobile_solar_mp/constants/error_handling.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';

class VerificationService {
  Future<void> verifyOTP({
    required BuildContext context,
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await HttpClient.http.post(
      Uri.parse('$uri/Twilio/verifyOtp?phoneNumber=$phoneNumber&otp=$otp'),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {},
      );
    }
  }

  Future<void> resendOTP({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    final response = await HttpClient.http.post(
      Uri.parse('$uri/Twilio/sendOtp'),
      body: json.encode({'phoneNumber': phoneNumber}),
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
