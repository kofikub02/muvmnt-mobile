import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';
import 'package:mvmnt_cli/features/support/domain/repository/session_messages_repository.dart';

class LoadSessionMessagesUseCase {
  final SessionMessagesRepository repository;

  LoadSessionMessagesUseCase(this.repository);

  Future<DataState<List<SessionMessageEntity>>> call(String sessionId) {
    return repository.loadSessionMessages(sessionId);
  }
}
