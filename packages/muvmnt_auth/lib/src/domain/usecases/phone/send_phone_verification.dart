import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class SendPhoneVerificationUseCase {
  final AuthRepository _phoneAuthRepository;

  SendPhoneVerificationUseCase(this._phoneAuthRepository);

  Future<DataState<void>> call(SendPhoneVerificationUseCaseParams params) {
    return _phoneAuthRepository.sendPhoneVerification(
      phoneNumber: params.phoneNumber,
      onVerificaitonFailed: params.onVerificationFailed,
      onCodeSent: params.onCodeSent,
      onCodeAutoRetrievalTimeOut: params.onCodeAutoRetrievalTimeOut,
      forceResendingToken: params.resendToken,
    );
  }
}

class SendPhoneVerificationUseCaseParams {
  final String phoneNumber;
  final int? resendToken;
  final dynamic onVerificationFailed;
  final void Function(String verificationId, int? resendToken) onCodeSent;
  final void Function(String verificationId) onCodeAutoRetrievalTimeOut;

  SendPhoneVerificationUseCaseParams({
    required this.phoneNumber,
    this.resendToken,
    required this.onVerificationFailed,
    required this.onCodeSent,
    required this.onCodeAutoRetrievalTimeOut,
  });
}
