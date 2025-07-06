import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/paypal_repository.dart';

class GetPaypalMethodsUseCase {
  final PaypalRepository repository;

  GetPaypalMethodsUseCase(this.repository);

  Future<DataState<List<PaymentMethodEntity>>> call() async {
    return repository.getMethods();
  }
}
