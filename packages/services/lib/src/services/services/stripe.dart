import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/remote/stripe_remote_datasource.dart';

class StripeService {

  StripeService({required this.dio});
  final Dio dio;

  Future<void> initialize() async {
    try {
      final Map<String, dynamic> config =
          await serviceLocator<StripeRemoteDatasource>().getConfig();
      Stripe.publishableKey = config['pubKey'];
      Stripe.merchantIdentifier = 'merchant.muvmnt.cli';
      await Stripe.instance.applySettings();
    } catch (error) {
      print(error);
    }
  }
}
