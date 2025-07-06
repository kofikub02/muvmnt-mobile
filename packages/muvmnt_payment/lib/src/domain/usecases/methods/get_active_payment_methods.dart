import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/payment_methods_repository.dart';

class GetActivePaymentMethodTypesUseCase {

  GetActivePaymentMethodTypesUseCase(this.repository);
  final PaymentMethodsRepository repository;

  Future<DataState<List<PaymentMethodType>>> call() {
    return repository.getActivePaymentMethods();
  }
}
