import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/notifications/data/datasource/local/messaging_firebase_service.dart';
import 'package:mvmnt_cli/features/notifications/domain/repository/notification_service_repository.dart';

class NotificationServiceRepositoryImpl extends NotificationServiceRepository {

  NotificationServiceRepositoryImpl({required this.messagingFirebaseService});
  final MessagingFirebaseService messagingFirebaseService;

  @override
  Future<DataState<void>> initialize() async {
    try {
      await messagingFirebaseService.init();
      return DataSuccess(null);
    } catch (e) {
      print(e);
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(),
          error: e.toString(),
        ),
      );
    }
  }
}
