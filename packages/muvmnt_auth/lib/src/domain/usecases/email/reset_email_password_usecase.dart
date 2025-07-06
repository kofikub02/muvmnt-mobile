import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class ResetEmailPasswordUseCase {
  final AuthRepository _authRepository;

  ResetEmailPasswordUseCase(this._authRepository);

  Future<DataState<void>> call(String email) async {
    return await _authRepository.resetEmailPassword(email);
  }
}
