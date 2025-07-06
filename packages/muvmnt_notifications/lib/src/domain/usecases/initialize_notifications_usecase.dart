import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/notifications/domain/repository/notification_service_repository.dart';

class InitializeNotificationsUsecase {

  InitializeNotificationsUsecase({required this.notificationServiceRepository});
  final NotificationServiceRepository notificationServiceRepository;

  Future<DataState<void>> call() {
    return notificationServiceRepository.initialize();
  }
}
