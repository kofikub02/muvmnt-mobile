import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/get_safety_usecase.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/update_safety_usecase.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/safety/safety_state.dart';

final String deliverySafety = 'delivery_code';

class SafetyCubit extends Cubit<SafetyState> {
  final GetSafetyUsecase getSafetyUsecase;
  final UpdateSafetyUsecase updateSafetyUsecase;

  SafetyCubit({
    required this.getSafetyUsecase,
    required this.updateSafetyUsecase,
  }) : super(SafetyState.initial());

  Future updateDeliveryCodeStatus(Map<String, bool> setting) async {
    if (state.settings == null) {
      return;
    }
    emit(state.copyWith(status: SafetyStatus.loading));
    final result = await updateSafetyUsecase(state.settings!.id, setting);

    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: SafetyStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: SafetyStatus.success,
          settings: result.data,
          errorMessage: null,
        ),
      );
    }
  }

  Future getDeliveryCodeStatus() async {
    if (state.settings != null) {
      return;
    }

    emit(state.copyWith(status: SafetyStatus.loading));
    final result = await getSafetyUsecase();
    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: SafetyStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(state.copyWith(status: SafetyStatus.success, settings: result.data));
    }
  }
}
