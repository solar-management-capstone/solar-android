import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/http/http_client.dart';
import 'package:mobile_solar_mp/constants/error_handling.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/models/package.dart';

class PackageService {
  Future<List<Package>> getPackagesFilter({
    required BuildContext context,
    required int roofArea,
    required double electricBill,
  }) async {
    List<Package> listPackage = [];

    final response = await HttpClient.http.get(
      Uri.parse(
        '$uri/Package/sort?roofArea=$roofArea&electricBill=$electricBill',
      ),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = json.decode(response.body);
          for (var i = 0; i < data['data'].length; i++) {
            final entry = data['data'][i];
            Package package = Package.fromJson(entry);
            listPackage.add(package);
          }
        },
      );
    }

    return listPackage;
  }

  Future<List<Package>> getPackages({
    required BuildContext context,
  }) async {
    List<Package> listPackage = [];

    final response = await HttpClient.http.get(
      Uri.parse(
        '$uri/Package/get-Package',
      ),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = json.decode(response.body);
          for (var i = 0; i < data['data'].length; i++) {
            final entry = data['data'][i];
            Package package = Package.fromJson(entry);
            listPackage.add(package);
          }
        },
      );
    }

    return listPackage;
  }

  Future<List<Package>> getPackagesByName({
    required BuildContext context,
    required String name,
  }) async {
    List<Package> listPackage = [];

    final response = await HttpClient.http.get(
      Uri.parse(
        '$uri/Package/get-name?name=$name',
      ),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = json.decode(response.body);
          for (var i = 0; i < data['data'].length; i++) {
            final entry = data['data'][i];
            Package package = Package.fromJson(entry);
            listPackage.add(package);
          }
        },
      );
    }

    return listPackage;
  }
}
