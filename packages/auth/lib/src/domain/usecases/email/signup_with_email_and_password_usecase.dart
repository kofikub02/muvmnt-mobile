import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/domain/repository/auth_repository.dart';

class SignupWithEmailAndPasswordUsecase {
  final AuthRepository _authRepository;

  SignupWithEmailAndPasswordUsecase(this._authRepository);

  Future<DataState<void>> call({String? email, String? password}) {
    return _authRepository.signUpWithEmailAndPassword(email!, password!);
  }
}
