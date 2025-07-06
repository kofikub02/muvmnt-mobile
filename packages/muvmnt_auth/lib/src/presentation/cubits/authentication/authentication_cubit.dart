import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvmnt_auth/src/domain/entities/auth_entity.dart';
import 'package:muvmnt_auth/src/domain/usecases/signout_usecase.dart';
import 'package:muvmnt_auth/src/domain/usecases/stream_auth_state.dart';
import 'package:muvmnt_core/muvmnt_core.dart';
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
