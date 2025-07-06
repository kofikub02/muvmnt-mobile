import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/notifications/domain/usecases/initialize_notifications_usecase.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notifications_service/notification_service_state.dart';

class NotificationServiceCubit extends Cubit<NotificationServiceState> {

  NotificationServiceCubit({required this.initializeNotificationsUsecase})
    : super(NotificationServiceInitial());
  final InitializeNotificationsUsecase initializeNotificationsUsecase;

  Future requestNotificationPermission() async {
    emit(NotificationServiceLoading());

    final permissionResult = await initializeNotificationsUsecase();

    if (permissionResult is DataSuccess) {
      emit(NotificationServiceInitialized());
    } else {
      emit(
        NotificationServiceError(
          message: permissionResult.error?.message ?? 'Unknown error',
        ),
      );
    }
  }
}
