import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/paypal_repository.dart';

class SetupPaypalTokenUseCase {
  final PaypalRepository _repository;

  SetupPaypalTokenUseCase(this._repository);

  Future<DataState<Map<String, dynamic>>> call() {
    return _repository.setupPaymentToken();
  }
}
