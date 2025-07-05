import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/notifications/data/datasource/remote/notification_preferences_remote_data_source.dart';
import 'package:mvmnt_cli/features/notifications/data/models/notification_preference_model.dart';
import 'package:mvmnt_cli/features/notifications/domain/entities/notification_preference_entity.dart';
import 'package:mvmnt_cli/features/notifications/domain/repository/notification_preference_repository.dart';

class NotificationPreferenceRepositoryImpl
    extends NotificationPreferenceRepository {
  final NotificationPreferencesRemoteDataSource
  notificationPreferencesRemoteDataSource;

  NotificationPreferenceRepositoryImpl({
    required this.notificationPreferencesRemoteDataSource,
  });

  @override
  Future<DataState<List<NotificationPreferenceEntity>>> getPreferences() async {
    try {
      final result =
          await notificationPreferencesRemoteDataSource.getPreferences();
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.message,
        ),
      );
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
  Future<DataState<NotificationPreferenceEntity>> updatePreference(
    String preferenceId,
    NotificationPreferenceChannelEntity channelSetting,
  ) async {
    try {
      final result = await notificationPreferencesRemoteDataSource
          .updatePreference(
            preferenceId,
            NotificationPreferenceChannelModel.fromEntity(channelSetting),
          );
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.message,
        ),
      );
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
