import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/core/resources/usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/repository/auth_repository.dart';

class SigninWithFacebookUseCase extends UseCase {
  final AuthRepository _authRepository;

  SigninWithFacebookUseCase(this._authRepository);

  @override
  Future<DataState<void>> call({params}) {
    return _authRepository.signInWithFacebook();
  }
}
