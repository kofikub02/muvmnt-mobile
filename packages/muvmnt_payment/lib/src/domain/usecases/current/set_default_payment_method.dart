import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/current_payment_repository.dart';

class SetDefaultPaymentMethodUseCase {

  SetDefaultPaymentMethodUseCase(this.repository);
  final CurrentPaymentRepository repository;

  Future<DataState<void>> call(PaymentMethodEntity paymentMethod) {
    return repository.setDefaultPaymentMethod(paymentMethod);
  }
}
