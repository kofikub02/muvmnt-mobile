import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/notifications/domain/entities/notification_preference_entity.dart';
import 'package:mvmnt_cli/features/notifications/domain/repository/notification_preference_repository.dart';

class GetNotificationPreferencesUsecase {
  final NotificationPreferenceRepository notificationPreferenceRepository;

  GetNotificationPreferencesUsecase({
    required this.notificationPreferenceRepository,
  });

  Future<DataState<List<NotificationPreferenceEntity>>> call() {
    return notificationPreferenceRepository.getPreferences();
  }
}
