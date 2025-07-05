import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/notifications/domain/repository/notification_service_repository.dart';

class InitializeNotificationsUsecase {
  final NotificationServiceRepository notificationServiceRepository;

  InitializeNotificationsUsecase({required this.notificationServiceRepository});

  Future<DataState<void>> call() {
    return notificationServiceRepository.initialize();
  }
}
