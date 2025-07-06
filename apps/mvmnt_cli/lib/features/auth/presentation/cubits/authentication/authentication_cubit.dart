import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/domain/entities/auth_entity.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/signout_usecase.dart';
import 'package:mvmnt_cli/features/auth/domain/usecases/stream_auth_state.dart';
import 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final SignoutUseCase signOutUseCase;
  final StreamAuthStateUseCase streamAuthStateUseCase;

  StreamSubscription<DataState<AuthEntity?>>? _authStreamSub;
  StreamSubscription<dynamic>? _idStreamSub;

  AuthenticationCubit({
    required this.signOutUseCase,
    required this.streamAuthStateUseCase,
  }) : super(AuthenticationState.initial()) {
    _listenToAuthChanges();
    _listenToIdTokenChanges();
  }

  void _listenToIdTokenChanges() {
    _idStreamSub = serviceLocator<FirebaseAuth>().idTokenChanges().listen(
      (user) {},
    );
  }

  void _listenToAuthChanges() {
    _authStreamSub = streamAuthStateUseCase().listen((authState) {
      emit(state.copyWith(status: AuthenticationStatus.loading));
      if (authState is DataSuccess && authState.data != null) {
        emit(
          state.copyWith(
            status: AuthenticationStatus.authenticated,
            authEntity: authState.data!,
          ),
        );
      } else {
        emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      }
    });
  }

  Future<void> signOutPressed() async {
    emit(state.copyWith(status: AuthenticationStatus.loading));
    final result = await signOutUseCase();
    result is DataFailed
        ? emit(
          state.copyWith(
            status: AuthenticationStatus.failure,
            errorMessage: result.error?.message ?? 'Sign out failed',
          ),
        )
        : null;
  }

  void clearError() {
    if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      emit(state.copyWith(errorMessage: null));
    }
  }

  @override
  Future<void> close() {
    _authStreamSub?.cancel();
    _idStreamSub?.cancel();
    return super.close();
  }
}
