import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/http/http_client.dart';
import 'package:mobile_solar_mp/constants/error_handling.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';

class HistoryConstructionContractService {
  Future<List<ConstructionContract>> getConstructionContract({
    required BuildContext context,
    required int status,
  }) async {
    List<ConstructionContract> listConstructionContract = [];
    String customerId = SharedPreferencesUtils.getId()!;
    final response = await HttpClient.http.get(
      Uri.parse(
        '$uri/ConstructionContract/get-Construction-Contract-by-Customerid?customerId=$customerId&status=$status',
      ),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = json.decode(response.body);
          if (data['data'] != null) {
            for (var i = 0; i < data['data']?.length; i++) {
              final entry = data['data'][i];
              ConstructionContract constructionContract =
                  ConstructionContract.fromJson(entry);
              listConstructionContract.add(constructionContract);
            }
          }
        },
      );
    }

    return listConstructionContract;
  }
}
