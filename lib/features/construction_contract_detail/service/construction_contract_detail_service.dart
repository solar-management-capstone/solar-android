import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/http/http_client.dart';
import 'package:mobile_solar_mp/constants/error_handling.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/models/construction_contract.dart';
import 'package:mobile_solar_mp/models/payment.dart';

class ConstructionContractDetailService {
  Future<ConstructionContract> getConstructionContractById({
    required BuildContext context,
    required String constructionContractId,
  }) async {
    ConstructionContract constructionContract = ConstructionContract();
    final response = await HttpClient.http.get(
      Uri.parse(
        '$uri/ConstructionContract/get-Construction-Contract-by-id?constructionContractId=$constructionContractId',
      ),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          constructionContract =
              ConstructionContract.fromJson(json.decode(response.body)['data']);
        },
      );
    }

    return constructionContract;
  }

  Future<Payment> createPayment({
    required BuildContext context,
    required String constructionContractId,
    required String accountId,
  }) async {
    late Payment payment;
    final response = await HttpClient.http.post(
      Uri.parse(
        '$uri/Payment/Insert-payment',
      ),
      body: json.encode({
        'constructionContractId': constructionContractId,
        // 'isDeposit': true,
        'accountId': accountId
      }),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          payment = Payment.fromJson(json.decode(response.body)['data']);
        },
      );
    }

    return payment;
  }

  Future<String> getUrlVnPay({
    required BuildContext context,
    required String paymentId,
  }) async {
    late String url;
    final response = await HttpClient.http.get(
      Uri.parse(
        '$uri/VNPay?paymentId=$paymentId',
      ),
    );

    if (context.mounted) {
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          url = response.body;
        },
      );
    }

    return url;
  }

  Future<void> cancelConstructionContract({
    required BuildContext context,
    required String constructionContractId,
  }) async {
    ConstructionContract constructionContract =
        await getConstructionContractById(
      context: context,
      constructionContractId: constructionContractId,
    );
    constructionContract.status = '0';

    final response = await HttpClient.http.put(
      Uri.parse(
        '$uri/ConstructionContract/Update-construction-contract-with-id',
      ),
      body: json.encode(constructionContract),
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
