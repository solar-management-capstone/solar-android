import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/constants/utils.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 201:
      onSuccess();
      break;
    case 204:
      onSuccess();
      break;
    case 400:
      if (json.decode(response.body)['message'] != null) {
        throw CustomException(json.decode(response.body)['message'], 400);
      } else if (json.decode(response.body)['Message'] != null) {
        throw CustomException(json.decode(response.body)['Message'], 400);
      } else {
        throw CustomException(json.decode(response.body).toString(), 400);
      }
    case 500:
      showSnackBar(
        context,
        json.decode(response.body).toString(),
        color: Colors.red,
      );
      throw Exception();
    default:
      showSnackBar(context, response.body);
  }
}
