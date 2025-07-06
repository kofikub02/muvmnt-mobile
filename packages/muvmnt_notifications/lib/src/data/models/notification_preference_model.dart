// ignore_for_file: overridden_fields, annotate_overrides
import 'package:mvmnt_cli/features/notifications/domain/entities/notification_preference_entity.dart';

class NotificationPreferenceTopicModel
    extends NotificationPreferenceTopicEntity {

  factory NotificationPreferenceTopicModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferenceTopicModel(
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
  const NotificationPreferenceTopicModel({
    required super.name,
    required super.description,
  });

  factory NotificationPreferenceTopicModel.fromEntity(
    NotificationPreferenceTopicEntity entity,
  ) {
    return NotificationPreferenceTopicModel(
      name: entity.name,
      description: entity.description,
    );
  }

  NotificationPreferenceTopicEntity toEntity() {
    return NotificationPreferenceTopicEntity(
      name: name,
      description: description,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description};
  }
}

class NotificationPreferenceChannelModel
    extends NotificationPreferenceChannelEntity {

  factory NotificationPreferenceChannelModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationPreferenceChannelModel(
      type: NotificationChannel.values.firstWhere(
        (e) => e.name == json['type'],
        orElse:
            () =>
                throw ArgumentError(
                  'Invalid NotificationChannel type: ${json['type']}',
                ),
      ),
      status: json['status'] as bool,
    );
  }
  const NotificationPreferenceChannelModel({
    required super.type,
    required super.status,
  });

  factory NotificationPreferenceChannelModel.fromEntity(
    NotificationPreferenceChannelEntity entity,
  ) {
    return NotificationPreferenceChannelModel(
      type: entity.type,
      status: entity.status,
    );
  }

  NotificationPreferenceChannelEntity toEntity() {
    return NotificationPreferenceChannelEntity(type: type, status: status);
  }

  Map<String, dynamic> toJson() {
    return {'type': type.name, 'status': status};
  }
}

/// DTO for NotificationPreference
class NotificationPreferenceModel extends NotificationPreferenceEntity {

  const NotificationPreferenceModel({
    required this.id,
    required this.topic,
    required this.channels,
    required this.updatedAt,
  }) : super(id: id, topic: topic, channels: channels, updatedAt: updatedAt);

  /// Convert from entity to model
  factory NotificationPreferenceModel.fromEntity(
    NotificationPreferenceEntity entity,
  ) {
    return NotificationPreferenceModel(
      id: entity.id,
      topic: NotificationPreferenceTopicModel.fromEntity(entity.topic),
      channels:
          entity.channels
              .map(
                (channel) =>
                    NotificationPreferenceChannelModel.fromEntity(channel),
              )
              .toList(),
      updatedAt: entity.updatedAt,
    );
  }

  /// Create from JSON map
  factory NotificationPreferenceModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferenceModel(
      id: json['_id'] as String,
      topic: NotificationPreferenceTopicModel.fromJson(
        json['topic'] as Map<String, dynamic>,
      ),
      channels:
          (json['channels'] as List)
              .map(
                (channelJson) => NotificationPreferenceChannelModel.fromJson(
                  channelJson as Map<String, dynamic>,
                ),
              )
              .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
  final String id;
  final NotificationPreferenceTopicModel topic;
  final List<NotificationPreferenceChannelModel> channels;
  final DateTime updatedAt;

  /// Convert model to entity
  NotificationPreferenceEntity toEntity() {
    return NotificationPreferenceEntity(
      id: id,
      topic: topic.toEntity(),
      channels: channels.map((channel) => channel.toEntity()).toList(),
      updatedAt: updatedAt,
    );
  }

  /// Get a specific channel by type
  NotificationPreferenceChannelModel? getChannel(String channelType) {
    try {
      return channels.firstWhere(
        (channel) => channel.type.toString().split('.').last == channelType,
      );
    } catch (_) {
      return null;
    }
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic.toJson(),
      'channels': channels.map((channel) => channel.toJson()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, topic, channels, updatedAt];
}
