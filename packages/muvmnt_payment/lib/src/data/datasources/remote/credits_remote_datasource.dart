import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/payments/data/models/payment_credits_model.dart';

class CreditsRemoteDataSource {

  CreditsRemoteDataSource({required this.dio});
  final Dio dio;

  Future<PaymentCreditsModel> getCredits() async {
    final response = await dio.get('/payments/wallet');
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data['data'] != null) {
      return PaymentCreditsModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to fetch payment credits');
    }
  }
}
