import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/settings/data/datasource/remote/safety_remote_datasource.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/safety_settings_entity.dart';
import 'package:mvmnt_cli/features/settings/domain/repository/safety_repository.dart';

class SafetyRepositoryImpl extends SafetyRepository {
  final SafetyRemoteDatasource safetyRemoteDatasource;

  SafetyRepositoryImpl({required this.safetyRemoteDatasource});

  @override
  Future<DataState<SafetySettingsEntity>> getSafetySettings() async {
    try {
      final result = await safetyRemoteDatasource.getOption();
      return DataSuccess(result);
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
  Future<DataState<SafetySettingsEntity>> updateSafetySettings(
    String id,
    Map<String, bool> setting,
  ) async {
    try {
      final result = await safetyRemoteDatasource.updateOption(id, setting);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }
}
