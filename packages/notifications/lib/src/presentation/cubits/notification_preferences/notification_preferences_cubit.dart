import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/notifications/domain/entities/notification_preference_entity.dart';
import 'package:mvmnt_cli/features/notifications/domain/usecases/get_notification_preferences_usecase.dart';
import 'package:mvmnt_cli/features/notifications/domain/usecases/update_notification_preference_usecase.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notification_preferences/notification_preferences_state.dart';

class NotificationPreferencesCubit extends Cubit<NotificationPreferencesState> {

  NotificationPreferencesCubit({
    required this.getNotificationPreferencesUsecase,
    required this.updateNotificationPreferenceUsecase,
  }) : super(NotificationPreferencesState.initial());
  final GetNotificationPreferencesUsecase getNotificationPreferencesUsecase;
  final UpdateNotificationPreferenceUsecase updateNotificationPreferenceUsecase;

  Future<void> getPreferences() async {
    if (state.notificationPreferencesEntity.isNotEmpty) {
      return;
    }

    emit(state.copyWith(status: NotificationPreferenceStatus.loading));

    final results = await getNotificationPreferencesUsecase();

    (results is DataSuccess)
        ? emit(
          state.copyWith(
            status: NotificationPreferenceStatus.success,
            notificationPreferencesEntity: results.data,
          ),
        )
        : emit(
          state.copyWith(
            status: NotificationPreferenceStatus.error,
            errorMessage:
                results.error!.message ??
                'Failed to load notification preferences',
          ),
        );
  }

  Future<void> updatePreferences(
    String id,
    NotificationPreferenceChannelEntity channelSetting,
  ) async {
    emit(state.copyWith(status: NotificationPreferenceStatus.updating));

    final result = await updateNotificationPreferenceUsecase(
      id: id,
      channelSetting: channelSetting,
    );

    (result is DataSuccess)
        ? emit(
          state.copyWith(
            status: NotificationPreferenceStatus.success,
            notificationPreferencesEntity:
                state.notificationPreferencesEntity
                    .map<NotificationPreferenceEntity>(
                      (n) => n.id == result.data!.id ? result.data! : n,
                    )
                    .toList(),
          ),
        )
        : emit(
          state.copyWith(
            status: NotificationPreferenceStatus.error,
            errorMessage:
                result.error!.message ??
                'Failed to load notification preferences',
          ),
        );
  }
}
