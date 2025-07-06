import 'package:mvmnt_cli/core/storage/local_storage/user_local_storage.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';

class ThemeLocalDatasource {
  static const _currentKey = 'CURRENT_THEME';

  final UserLocalStorage localStorage;

  ThemeLocalDatasource({required this.localStorage});

  Future saveTheme(ThemeEntity theme) async {
    var themeValue =
        theme.themeType == ThemeType.dark
            ? 'dark'
            : theme.themeType == ThemeType.light
            ? 'light'
            : 'system';
    print(themeValue);
    await localStorage.set(_currentKey, themeValue);
  }

  Future<ThemeEntity> getTheme() async {
    var themeValue = localStorage.get(_currentKey);
    if (themeValue == 'dark') {
      return ThemeEntity(themeType: ThemeType.dark);
    } else if (themeValue == 'light') {
      return ThemeEntity(themeType: ThemeType.light);
    }

    return ThemeEntity(themeType: ThemeType.system);
  }
}
