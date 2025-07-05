import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/payments/data/models/payment_method_model.dart';

class PaypalRemoteDatasouce {

  PaypalRemoteDatasouce({required this.dio});
  final Dio dio;

  Future<List<PaymentMethodModel>> getMethods() async {
    final response = await dio.get('/payments/paypal/payment-methods');

    if (response.statusCode == 200) {
      final rawList = response.data['data'] as List;
      final paymentMethods =
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
    final setupTokenResponse = await dio.post('/payments/paypal/setup-token');

    if (setupTokenResponse.statusCode == 200) {
      return setupTokenResponse.data['data'];
    }

    throw setupTokenResponse.data['message'];
  }

  Future<PaymentMethodModel> createPaymentToken(String setupTokenId) async {
    final response = await dio.post(
      '/payments/paypal/payment-token',
      data: {'setupTokenId': setupTokenId},
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
    final response = await dio.delete(
      '/payments/paypal/payment-methods/$methodId',
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw response.data['message'];
  }
}
