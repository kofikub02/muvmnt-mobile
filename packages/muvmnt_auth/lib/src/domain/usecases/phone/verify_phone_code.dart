import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class VerifyPhoneCodeUseCase {
  final AuthRepository _phoneAuthRepository;

  VerifyPhoneCodeUseCase(this._phoneAuthRepository);

  Future<DataState<void>> call(VerifyPhoneCodeUseCaseParams params) {
    return _phoneAuthRepository.verifyPhoneCode(
      phoneCode: params.code,
      verificationId: params.verificationId,
    );
  }
}

class VerifyPhoneCodeUseCaseParams {
  final String code;
  final String verificationId;

  VerifyPhoneCodeUseCaseParams({
    required this.code,
    required this.verificationId,
  });
}
