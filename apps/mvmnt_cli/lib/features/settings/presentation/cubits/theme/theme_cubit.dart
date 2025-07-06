import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/get_theme_use_case.dart';
import 'package:mvmnt_cli/features/settings/domain/usecases/save_theme_use_case.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final GetThemeUseCase getThemeUseCase;
  final SaveThemeUseCase saveThemeUseCase;

  ThemeCubit({required this.getThemeUseCase, required this.saveThemeUseCase})
    : super(ThemeState.initial());

  Future getTheme() async {
    emit(state.copyWith(status: ThemeStatus.loading));
    final result = await getThemeUseCase();
    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: ThemeStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(
        state.copyWith(status: ThemeStatus.success, themeEntity: result.data),
      );
    }
  }

  Future setTheme(ThemeType type) async {
    emit(state.copyWith(status: ThemeStatus.loading));
    var newThemeEntity = ThemeEntity(themeType: type);
    final result = await saveThemeUseCase(newThemeEntity);
    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: ThemeStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ThemeStatus.success,
          themeEntity: newThemeEntity,
        ),
      );
    }
  }
}
