import 'package:dio/dio.dart';
import 'package:mvmnt_cli/features/notifications/data/models/notification_preference_model.dart';

class NotificationPreferencesRemoteDataSource {

  NotificationPreferencesRemoteDataSource({required this.dio});
  final Dio dio;

  Future<List<NotificationPreferenceModel>> getPreferences() async {
    final response = await dio.get('/notifications/preferences');

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map(
              (json) => NotificationPreferenceModel.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
      }
    }

    throw response.data['message'];
  }

  Future<NotificationPreferenceModel> updatePreference(
    String preferenceId,
    NotificationPreferenceChannelModel channelSetting,
  ) async {
    final response = await dio.patch(
      '/notifications/preferences/$preferenceId',
      data: channelSetting.toJson(),
    );
    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return NotificationPreferenceModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }
}
