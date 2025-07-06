import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/payment_methods_repository.dart';

class SavePaymentMethodTypeUseCase {
  final PaymentMethodsRepository repository;

  SavePaymentMethodTypeUseCase(this.repository);

  Future<DataState<void>> call(PaymentMethodType paymentMethod) {
    return repository.savePaymentMethod(paymentMethod);
  }
}
