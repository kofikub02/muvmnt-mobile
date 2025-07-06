import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/paypal_repository.dart';

class CreatePaypalPaymentTokenUseCase {
  final PaypalRepository _repository;

  CreatePaypalPaymentTokenUseCase(this._repository);

  Future<DataState<PaymentMethodEntity>> call(String setupTokenId) {
    return _repository.createPaymentToken(setupTokenId);
  }
}
