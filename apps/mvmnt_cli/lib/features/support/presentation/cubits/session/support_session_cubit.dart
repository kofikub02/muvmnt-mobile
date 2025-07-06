import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/domain/entities/support_session_entity.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/session/create_session_usecase.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/session/get_active_sessions_usecase.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/session/support_session_state.dart';

class SupportSessionCubit extends Cubit<SupportSessionState> {
  final GetActiveSessionsUsecase getActiveSessionsUseCase;
  final CreateSessionUsecase createSessionUsecase;

  SupportSessionCubit({
    required this.getActiveSessionsUseCase,
    required this.createSessionUsecase,
  }) : super(const SupportSessionState());

  Future<void> getActiveSessions() async {
    emit(state.copyWith(status: SessionStatus.loading));

    final result = await getActiveSessionsUseCase();

    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: SessionStatus.loaded,
          activeSessions: result.data,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: SessionStatus.error,
          errorMessage: result.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> initiateSession(String orderId) async {
    emit(state.copyWith(status: SessionStatus.loading));

    final result = await createSessionUsecase(orderId);

    if (result is DataSuccess<SupportSessionEntity>) {
      emit(
        state.copyWith(
          status: SessionStatus.created,
          activeSessions: [
            result.data!,
            ...state.activeSessions.where((s) => s.id != result.data!.id),
          ],
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: SessionStatus.error,
          errorMessage: result.error?.message ?? '',
        ),
      );
    }
  }
}
