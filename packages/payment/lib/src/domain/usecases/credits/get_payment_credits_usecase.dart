import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_credits_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/payment_credits_repository.dart';

class GetPaymentCreditsUseCase {
  final PaymentCreditsRepository repository;

  GetPaymentCreditsUseCase(this.repository);

  Future<DataState<PaymentCreditsEntity>> call() {
    return repository.getCredits();
  }
}
