import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/theme_repository.dart';

class GetThemeUseCase {
  final ThemeRepository themeRepository;

  GetThemeUseCase({required this.themeRepository});

  Future<DataState<ThemeEntity>> call() async {
    return await themeRepository.getTheme();
  }
}
