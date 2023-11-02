import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/http/http_client.dart';
import 'package:mobile_solar_mp/constants/error_handling.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/models/package.dart';

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
}
