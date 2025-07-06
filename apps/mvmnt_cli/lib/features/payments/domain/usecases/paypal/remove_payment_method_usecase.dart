import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/paypal_repository.dart';

class RemovePaypalPaymentMethodUseCase {
  final PaypalRepository repository;

  RemovePaypalPaymentMethodUseCase(this.repository);

  Future<DataState<void>> call(String methodId) async {
    return repository.removeMethod(methodId);
  }
}
