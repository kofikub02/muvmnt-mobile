import 'package:equatable/equatable.dart';

enum NotificationChannel { email, push, sms }

class NotificationPreferenceTopicEntity {
  final String name;
  final String description;

  const NotificationPreferenceTopicEntity({
    required this.name,
    required this.description,
  });
}

class NotificationPreferenceChannelEntity {
  final NotificationChannel type;
  final bool status;

  const NotificationPreferenceChannelEntity({
    required this.type,
    required this.status,
  });

  /// Create a copy with updated fields
  NotificationPreferenceChannelEntity copyWith({
    NotificationChannel? type,
    bool? status,
  }) {
    return NotificationPreferenceChannelEntity(
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}

class NotificationPreferenceEntity extends Equatable {
  final String id;
  final NotificationPreferenceTopicEntity topic;
  final List<NotificationPreferenceChannelEntity> channels;
  final DateTime updatedAt;

  const NotificationPreferenceEntity({
    required this.id,
    required this.topic,
    required this.channels,
    required this.updatedAt,
  });

  /// Create a copy with updated fields
  NotificationPreferenceEntity copyWith({
    String? id,
    NotificationPreferenceTopicEntity? topic,
    List<NotificationPreferenceChannelEntity>? channels,
    DateTime? updatedAt,
  }) {
    return NotificationPreferenceEntity(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      channels: channels ?? this.channels,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, topic, channels, updatedAt];
}
