import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/payments/data/models/payment_method_model.dart';

class PaypalRemoteDatasouce {
  final Dio dio;

  PaypalRemoteDatasouce({required this.dio});

  Future<List<PaymentMethodModel>> getMethods() async {
    var response = await dio.get('/payments/paypal/payment-methods');

    if (response.statusCode == 200) {
      final rawList = response.data['data'] as List;
      final List<PaymentMethodModel> paymentMethods =
          rawList
              .map(
                (json) => PaymentMethodModel.fromJson({
                  'id': json['id'],
                  'name': 'Paypal',
                  'meta': json['maskedInfo']['email'],
                  'icon': 'paypal',
                  'type': 'paypal',
                }),
              )
              .toList();
      return paymentMethods;
    }

    throw response.data['error'] ?? 'Unknown error';
  }

  Future<Map<String, dynamic>> createSetupToken() async {
    var setupTokenResponse = await dio.post('/payments/paypal/setup-token');

    if (setupTokenResponse.statusCode == 200) {
      return setupTokenResponse.data['data'];
    }

    throw setupTokenResponse.data['message'];
  }

  Future<PaymentMethodModel> createPaymentToken(String setupTokenId) async {
    var response = await dio.post(
      '/payments/paypal/payment-token',
      data: {"setupTokenId": setupTokenId},
    );

    if (response.statusCode == 200) {
      final json = response.data['data'];
      return PaymentMethodModel.fromJson({
        'id': json['id'],
        'name': 'Paypal',
        'meta': json['maskedInfo']['email'],
        'icon': 'paypal',
        'type': 'paypal',
      });
    }

    throw response.data['error'];
  }

  Future<void> removePaypalMethod(String methodId) async {
    var response = await dio.delete(
      '/payments/paypal/payment-methods/$methodId',
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw response.data['message'];
  }
}
