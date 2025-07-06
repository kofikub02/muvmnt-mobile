import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvmnt_auth/src/domain/usecases/social/signin_annonymously_usecase.dart';
import 'package:muvmnt_auth/src/domain/usecases/social/signin_with_apple_usecase.dart';
import 'package:muvmnt_auth/src/domain/usecases/social/signin_with_facebook_usecase.dart';
import 'package:muvmnt_auth/src/domain/usecases/social/signin_with_google_usecase.dart';
import 'package:muvmnt_auth/src/presentation/cubits/social_auth/social_auth_state.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class SocialAuthCubit extends Cubit<SocialAuthState> {
  final SigninWithAppleUseCase signinWithAppleUseCase;
  final SigninWithGoogleUseCase signinWithGoogleUseCase;
  final SigninWithFacebookUseCase signinWithFacebookUseCase;
  final SignInAnonymousUseCase signInAnonymousUseCase;

  SocialAuthCubit({
    required this.signinWithAppleUseCase,
    required this.signinWithGoogleUseCase,
    required this.signinWithFacebookUseCase,
    required this.signInAnonymousUseCase,
  }) : super(SocialAuthState());

  Future<void> signInWithGooglePressed() async {
    emit(state.copyWith(status: SocialAuthStatus.loading));
    final result = await signinWithGoogleUseCase();
    result is DataFailed
        ? emit(
          state.copyWith(
            status: SocialAuthStatus.failure,
            errorMessage: result.error?.message ?? 'Unknown error',
          ),
        )
        : null;
  }

  Future<void> signInWithApplePressed() async {
    emit(state.copyWith(status: SocialAuthStatus.loading));
    final result = await signinWithAppleUseCase();
    result is DataFailed
        ? emit(
          state.copyWith(
            status: SocialAuthStatus.failure,
            errorMessage: result.error?.message ?? 'Unknown error',
          ),
        )
        : null;
  }

  Future<void> signInWithFacebookPressed() async {
    emit(state.copyWith(status: SocialAuthStatus.loading));
    final result = await signinWithFacebookUseCase();
    result is DataFailed
        ? emit(
          state.copyWith(
            status: SocialAuthStatus.failure,
            errorMessage: result.error?.message ?? 'Unknown error',
          ),
        )
        : null;
  }

  Future<void> signInAnonymousInitiated() async {
    emit(state.copyWith(status: SocialAuthStatus.loading));
    final result = await signInAnonymousUseCase();
    result is DataFailed
        ? emit(
          state.copyWith(
            status: SocialAuthStatus.failure,
            errorMessage: result.error?.message ?? 'Unknown error',
          ),
        )
        : null;
  }
}
