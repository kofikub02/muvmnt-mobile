import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/domain/repository/auth_repository.dart';

class ConfirmEmailVerificationUseCase {
  final AuthRepository repository;

  ConfirmEmailVerificationUseCase(this.repository);

  Future<DataState<bool>> call() async {
    return await repository.confirmEmailVerification();
  }
}
