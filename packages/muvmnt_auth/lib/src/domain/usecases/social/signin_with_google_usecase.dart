import 'package:muvmnt_core/muvmnt_core.dart';
import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';

class SigninWithGoogleUseCase extends UseCase {
  final AuthRepository _authRepository;

  SigninWithGoogleUseCase(this._authRepository);

  @override
  Future<DataState<void>> call({params}) {
    return _authRepository.signInWithGoogle();
  }
}
