import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/stripe_repository.dart';

class SaveCardMethodUseCase {

  SaveCardMethodUseCase(this.repository);
  final StripeRepository repository;

  Future<DataState<void>> call() async {
    return repository.saveCardMethod();
  }
}
