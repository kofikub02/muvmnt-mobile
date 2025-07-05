import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_credits_entity.dart';

abstract class PaymentCreditsRepository {
  Future<DataState<PaymentCreditsEntity>> getCredits();
}
