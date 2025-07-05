import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/stripe_repository.dart';

class RemoveCardMethodUseCase {
  final StripeRepository repository;

  RemoveCardMethodUseCase(this.repository);

  Future<DataState<void>> call(String paymentId) async {
    return repository.removeCardMethod(paymentId);
  }
}
