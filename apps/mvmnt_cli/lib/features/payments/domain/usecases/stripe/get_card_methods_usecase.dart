import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/stripe_repository.dart';

class GetCardMethodsUseCase {
  final StripeRepository repository;

  GetCardMethodsUseCase(this.repository);

  Future<DataState<List<PaymentMethodEntity>>> call() async {
    return repository.retrieveCardMethods();
  }
}
