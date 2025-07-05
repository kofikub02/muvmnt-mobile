import 'package:mvmnt_cli/core/resources/usecase.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/domain/repository/auth_repository.dart';

class SignInAnonymousUseCase extends UseCase {
  final AuthRepository _authRepository;

  SignInAnonymousUseCase(this._authRepository);

  @override
  Future<DataState<void>> call({params}) {
    return _authRepository.signInAnonymous();
  }
}
