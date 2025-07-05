import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/stripe_repository.dart';

class SaveCardMethodUseCase {
  final StripeRepository repository;

  SaveCardMethodUseCase(this.repository);

  Future<DataState<void>> call() async {
    return repository.saveCardMethod();
  }
}
