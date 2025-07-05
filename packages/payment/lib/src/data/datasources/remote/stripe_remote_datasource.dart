import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mvmnt_cli/features/payments/data/models/payment_method_model.dart';

class StripeRemoteDatasource {

  StripeRemoteDatasource({required this.dio});
  final Dio dio;

  Future<Map<String, dynamic>> getConfig() async {
    final response = await dio.get('/payments/stripe/config');
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data['data'] != null) {
      return response.data['data'];
    }

    return {};
  }

  Future<List<PaymentMethodModel>> retrieveCardMethods() async {
    final response = await dio.get('/payments/stripe/payment-methods');

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map(
              (json) => PaymentMethodModel.fromJson({
                'id': json['id'],
                'name': '${json['card']['brand']}...${json['card']['last4']}',
                'meta':
                    'Exp. ${json['card']['exp_month']}/${json['card']['exp_year']}',
                'icon': json['card']['brand'],
                'type': 'card',
              }),
            )
            .toList();
      }
    }

    throw response.data['message'];
  }

  Future<void> saveCardMethod() async {
    final response = await dio.get('/payments/stripe/setup-intent');
    var setupIntentClientSecret = '';
    if (response.statusCode == 200 && response.data != null) {
      setupIntentClientSecret = response.data['data']['secret'];
    }

    if (setupIntentClientSecret.isEmpty) {
      throw 'Setup failed';
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        setupIntentClientSecret: setupIntentClientSecret,
        merchantDisplayName: 'Muvmnt',
        style: ThemeMode.system,
      ),
    );

    await Stripe.instance.presentPaymentSheet();
  }

  Future<void> removeCardMethod(String paymentId) async {
    final response = await dio.delete(
      '/payments/stripe/payment-methods/$paymentId',
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw response.data['message'];
  }
}
