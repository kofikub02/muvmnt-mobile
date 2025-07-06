import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/settings/data/datasource/local/theme_local_datasource.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDatasource themeLocalDatasource;

  ThemeRepositoryImpl({required this.themeLocalDatasource});

  @override
  Future<DataState<ThemeEntity>> getTheme() async {
    try {
      return DataSuccess(await themeLocalDatasource.getTheme());
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> saveTheme(ThemeEntity theme) async {
    try {
      await themeLocalDatasource.saveTheme(theme);
      return DataSuccess(null);
    } catch (e) {
      print('SAVE THEME');
      print(e);
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }
}
