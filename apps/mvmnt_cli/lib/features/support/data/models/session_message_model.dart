import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';

class SessionMessageModel extends SessionMessageEntity {
  const SessionMessageModel({
    required super.id,
    required super.content,
    required super.senderType,
    required super.createdAt,
  });

  factory SessionMessageModel.fromJson(Map<String, dynamic> json) {
    final dynamic created = json['createdAt'] ?? json['created_at'];

    final DateTime? createdAt = switch (created) {
      String s => DateTime.tryParse(s),
      int seconds => DateTime.fromMillisecondsSinceEpoch(seconds * 1000),
      _ => null,
    };

    return SessionMessageModel(
      id: json['id'] ?? json['_id'],
      content:
          (json['content'] as List).map((item) {
            return MessageContentModel.fromJson(item as Map<String, dynamic>);
          }).toList(),
      senderType: SenderType.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => SenderType.user,
      ),
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_type': senderType.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SessionMessageModel.fromEntity(SessionMessageEntity entity) {
    return SessionMessageModel(
      id: entity.id,
      content: entity.content,
      senderType: entity.senderType,
      createdAt: entity.createdAt,
    );
  }

  SessionMessageEntity toEntity() {
    return SessionMessageEntity(
      id: id,
      content: content,
      senderType: senderType,
      createdAt: createdAt,
    );
  }
}

class MessageContentModel extends MessageContentEntity {
  MessageContentModel({required super.type, required super.value});

  factory MessageContentModel.fromJson(Map<String, dynamic> json) {
    return MessageContentModel(
      type: MessageContentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageContentType.text,
      ),
      value: json[json['type']]['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type.toString().split('.').last, 'value': value};
  }

  factory MessageContentModel.fromEntity(MessageContentEntity entity) {
    return MessageContentModel(type: entity.type, value: entity.value);
  }

  MessageContentEntity toEntity() {
    return MessageContentEntity(type: type, value: value);
  }
}
