import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';
import 'package:mvmnt_cli/features/support/domain/repository/session_messages_repository.dart';

class SendSessionMessageUseCase {
  final SessionMessagesRepository repository;

  SendSessionMessageUseCase(this.repository);

  Future<DataState<SessionMessageEntity>> call({
    String? sessionId,
    MessageContentEntity? message,
  }) {
    return repository.sendSessionMessage(sessionId!, message!);
  }
}
