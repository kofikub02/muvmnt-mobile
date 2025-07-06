import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/notifications/domain/entities/notification_preference_entity.dart';
import 'package:mvmnt_cli/features/notifications/domain/repository/notification_preference_repository.dart';

class UpdateNotificationPreferenceUsecase {
  final NotificationPreferenceRepository notificationPreferenceRepository;

  UpdateNotificationPreferenceUsecase({
    required this.notificationPreferenceRepository,
  });

  Future<DataState<NotificationPreferenceEntity>> call({
    String? id,
    NotificationPreferenceChannelEntity? channelSetting,
  }) {
    return notificationPreferenceRepository.updatePreference(
      id!,
      channelSetting!,
    );
  }
}
