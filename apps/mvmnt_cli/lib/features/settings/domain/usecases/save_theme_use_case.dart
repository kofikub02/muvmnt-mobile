import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/theme_repository.dart';

class SaveThemeUseCase {
  final ThemeRepository themeRepository;

  SaveThemeUseCase({required this.themeRepository});

  Future call(ThemeEntity theme) async {
    return await themeRepository.saveTheme(theme);
  }
}
