import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/domain/repository/auth_repository.dart';

class SendEmailVerificationUseCase {
  final AuthRepository _authRepository;

  SendEmailVerificationUseCase(this._authRepository);

  Future<DataState<void>> call(String email, bool isNew) {
    return _authRepository.sendEmailVerification(email, isNew);
  }
}
