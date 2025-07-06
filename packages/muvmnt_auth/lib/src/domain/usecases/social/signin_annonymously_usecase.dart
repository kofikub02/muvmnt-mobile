import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class SignInAnonymousUseCase extends UseCase {
  final AuthRepository _authRepository;

  SignInAnonymousUseCase(this._authRepository);

  @override
  Future<DataState<void>> call({params}) {
    return _authRepository.signInAnonymous();
  }
}
