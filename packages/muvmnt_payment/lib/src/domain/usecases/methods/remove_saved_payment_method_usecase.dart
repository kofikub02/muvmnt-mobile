import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/payment_methods_repository.dart';

class RemovePaymentMethodTypeUseCase {

  RemovePaymentMethodTypeUseCase(this.repository);
  final PaymentMethodsRepository repository;

  Future<DataState<void>> call(PaymentMethodType paymentMethod) {
    return repository.removePaymentMethod(paymentMethod);
  }
}
