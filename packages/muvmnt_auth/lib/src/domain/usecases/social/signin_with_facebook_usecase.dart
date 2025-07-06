import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class SigninWithFacebookUseCase extends UseCase {
  final AuthRepository _authRepository;

  SigninWithFacebookUseCase(this._authRepository);

  @override
  Future<DataState<void>> call({params}) {
    return _authRepository.signInWithFacebook();
  }
}
