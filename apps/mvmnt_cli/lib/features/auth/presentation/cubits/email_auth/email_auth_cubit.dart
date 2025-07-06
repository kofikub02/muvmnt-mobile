import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/confirm_email_verification_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/reset_email_password_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/send_email_verification_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/signin_with_email_and_password_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/email/signup_with_email_and_password_usecase.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/email_auth/email_auth_state.dart';

class EmailAuthCubit extends Cubit<EmailAuthState> {
  final SigninWithEmailAndPasswordUsecase signinWithEmailUseCase;
  final SignupWithEmailAndPasswordUsecase signupWithEmailUseCase;
  final ResetEmailPasswordUseCase resetEmailPasswordUseCase;
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;
  final ConfirmEmailVerificationUseCase confirmEmailVerificationUseCase;

  EmailAuthCubit({
    required this.signinWithEmailUseCase,
    required this.signupWithEmailUseCase,
    required this.resetEmailPasswordUseCase,
    required this.sendEmailVerificationUseCase,
    required this.confirmEmailVerificationUseCase,
  }) : super(const EmailAuthState());

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(state.copyWith(status: EmailAuthStatus.loading));
    final result = await signinWithEmailUseCase(
      email: email,
      password: password,
    );

    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: EmailAuthStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(state.copyWith(status: EmailAuthStatus.success));
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    emit(state.copyWith(status: EmailAuthStatus.loading));
    final result = await signupWithEmailUseCase(
      email: email,
      password: password,
    );

    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: EmailAuthStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(state.copyWith(status: EmailAuthStatus.success));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(state.copyWith(status: EmailAuthStatus.loading));
    final result = await resetEmailPasswordUseCase(email);

    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: EmailAuthStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(state.copyWith(status: EmailAuthStatus.resetSuccess));
    }
  }

  Future<void> sendEmailVerificationRequested(String email, bool isNew) async {
    emit(state.copyWith(status: EmailAuthStatus.loading));
    final result = await sendEmailVerificationUseCase(email, isNew);

    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: EmailAuthStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(state.copyWith(status: EmailAuthStatus.verificationSent));
    }
  }

  Future<void> confirmEmailVerificationRequested() async {
    emit(state.copyWith(status: EmailAuthStatus.loading));
    final result = await confirmEmailVerificationUseCase();

    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: EmailAuthStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      if (result.data! == true) {
        emit(state.copyWith(status: EmailAuthStatus.verificationConfirmed));
      }
    }
  }

  void clearError() {
    if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      emit(state.copyWith(status: EmailAuthStatus.initial, errorMessage: ''));
    }
  }
}
