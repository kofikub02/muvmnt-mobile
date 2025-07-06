import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/domain/repository/auth_repository.dart';

class ResetEmailPasswordUseCase {
  final AuthRepository _authRepository;

  ResetEmailPasswordUseCase(this._authRepository);

  Future<DataState<void>> call(String email) async {
    return await _authRepository.resetEmailPassword(email);
  }
}
