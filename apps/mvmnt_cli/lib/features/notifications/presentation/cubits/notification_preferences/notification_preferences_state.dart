import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/notifications/domain/entities/notification_preference_entity.dart';

enum NotificationPreferenceStatus { initial, loading, updating, success, error }

class NotificationPreferencesState extends Equatable {
  final NotificationPreferenceStatus status;
  final String? errorMessage;
  final List<NotificationPreferenceEntity> notificationPreferencesEntity;

  const NotificationPreferencesState._({
    required this.status,
    this.errorMessage,
    required this.notificationPreferencesEntity,
  });

  factory NotificationPreferencesState.initial() =>
      NotificationPreferencesState._(
        status: NotificationPreferenceStatus.initial,
        notificationPreferencesEntity: [],
      );

  NotificationPreferencesState copyWith({
    NotificationPreferenceStatus? status,
    String? errorMessage,
    List<NotificationPreferenceEntity>? notificationPreferencesEntity,
  }) => NotificationPreferencesState._(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    notificationPreferencesEntity:
        notificationPreferencesEntity ?? this.notificationPreferencesEntity,
  );

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    notificationPreferencesEntity,
  ];
}
