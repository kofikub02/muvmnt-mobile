// chat_message.dart
import 'package:equatable/equatable.dart';

enum SenderType { user, assistant, admin }

class SessionMessageEntity extends Equatable {
  final String id;
  final SenderType senderType; // AI, User, Agent
  final List<MessageContentEntity> content;
  final DateTime createdAt;

  const SessionMessageEntity({
    required this.id,
    required this.senderType,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, senderType, content, createdAt];
}

enum MessageContentType { text, image }

class MessageContentEntity {
  final MessageContentType type;
  final String value;

  MessageContentEntity({required this.type, required this.value});
}
