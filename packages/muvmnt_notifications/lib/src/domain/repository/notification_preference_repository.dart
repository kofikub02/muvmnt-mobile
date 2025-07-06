import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/notifications/domain/entities/notification_preference_entity.dart';

abstract class NotificationPreferenceRepository {
  Future<DataState<List<NotificationPreferenceEntity>>> getPreferences();
  Future<DataState<NotificationPreferenceEntity>> updatePreference(
    String preferenceId,
    NotificationPreferenceChannelEntity channelSetting,
  );
}
