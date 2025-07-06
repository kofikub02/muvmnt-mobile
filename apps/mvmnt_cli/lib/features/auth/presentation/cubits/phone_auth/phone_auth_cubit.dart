import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/phone/send_phone_verification.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/phone/verify_phone_code.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/phone_auth/phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final SendPhoneVerificationUseCase sendPhoneVerificationUseCase;
  final VerifyPhoneCodeUseCase verifyPhoneCodeUseCase;

  PhoneAuthCubit({
    required this.sendPhoneVerificationUseCase,
    required this.verifyPhoneCodeUseCase,
  }) : super(const PhoneAuthState());

  void sendVerification(String phoneNumber, bool resendCode) async {
    emit(state.copyWith(status: PhoneAuthStatus.loading));

    await sendPhoneVerificationUseCase(
      SendPhoneVerificationUseCaseParams(
        phoneNumber: phoneNumber,
        resendToken: resendCode ? state.resendToken : null,
        onCodeSent: (verificationId, resendToken) {
          emit(
            state.copyWith(
              status: PhoneAuthStatus.codeSent,
              verificationId: verificationId,
              resendToken: resendToken,
            ),
          );
        },
        onVerificationFailed: (errorMessage) {
          emit(
            state.copyWith(
              status: PhoneAuthStatus.failure,
              errorMessage: errorMessage ?? "Verification failed",
            ),
          );
        },
        onCodeAutoRetrievalTimeOut: (String verificationId) {
          emit(
            state.copyWith(
              status: PhoneAuthStatus.timeout,
              verificationId: verificationId,
            ),
          );
        },
      ),
    );
  }

  void verifyCode(String smsCode) async {
    if (state.verificationId == null || state.verificationId!.isEmpty) {
      emit(
        state.copyWith(
          status: PhoneAuthStatus.failure,
          errorMessage: "Please verify number or resend code",
        ),
      );
      return;
    }

    emit(state.copyWith(status: PhoneAuthStatus.loading));

    final result = await verifyPhoneCodeUseCase(
      VerifyPhoneCodeUseCaseParams(
        verificationId: state.verificationId!,
        code: smsCode,
      ),
    );

    if (result is DataSuccess) {
      emit(state.copyWith(status: PhoneAuthStatus.verified));
    } else if (result is DataFailed) {
      emit(
        state.copyWith(
          status: PhoneAuthStatus.failure,
          errorMessage: result.error!.message ?? "Error occured",
        ),
      );
    }
  }

  void clearError() {
    if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      emit(state.copyWith(status: PhoneAuthStatus.initial, errorMessage: ''));
    }
  }
}
