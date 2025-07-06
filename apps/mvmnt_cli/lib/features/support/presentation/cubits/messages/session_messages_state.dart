import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';

enum SessionMessagesStatus { initial, loading, loaded, error }

class SessionMessagesState extends Equatable {
  final List<SessionMessageEntity> messages;
  final SessionMessagesStatus status;
  final String? errorMessage;
  final bool isTyping;

  const SessionMessagesState({
    this.messages = const [],
    this.status = SessionMessagesStatus.initial,
    this.errorMessage,
    this.isTyping = false,
  });

  SessionMessagesState copyWith({
    List<SessionMessageEntity>? messages,
    SessionMessagesStatus? status,
    String? errorMessage,
    bool? isTyping,
  }) {
    return SessionMessagesState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  List<Object?> get props => [messages, status, errorMessage, isTyping];
}
