import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/paypal_repository.dart';

class RemovePaypalPaymentMethodUseCase {

  RemovePaypalPaymentMethodUseCase(this.repository);
  final PaypalRepository repository;

  Future<DataState<void>> call(String methodId) async {
    return repository.removeMethod(methodId);
  }
}
