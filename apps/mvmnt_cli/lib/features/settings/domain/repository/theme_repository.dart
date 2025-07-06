import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';

abstract class ThemeRepository {
  Future<DataState<ThemeEntity>> getTheme();
  Future<DataState<void>> saveTheme(ThemeEntity theme);
}
