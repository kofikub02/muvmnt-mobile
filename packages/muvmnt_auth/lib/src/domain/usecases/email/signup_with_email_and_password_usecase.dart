import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class SignupWithEmailAndPasswordUsecase {
  final AuthRepository _authRepository;

  SignupWithEmailAndPasswordUsecase(this._authRepository);

  Future<DataState<void>> call({String? email, String? password}) {
    return _authRepository.signUpWithEmailAndPassword(email!, password!);
  }
}
