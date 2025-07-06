import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class SendEmailVerificationUseCase {
  final AuthRepository _authRepository;

  SendEmailVerificationUseCase(this._authRepository);

  Future<DataState<void>> call(String email, bool isNew) {
    return _authRepository.sendEmailVerification(email, isNew);
  }
}
