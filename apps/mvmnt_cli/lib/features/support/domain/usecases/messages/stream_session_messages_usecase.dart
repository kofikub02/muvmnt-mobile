import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/domain/repository/session_messages_repository.dart';

class StreamSessionMessagesUsecase {
  final SessionMessagesRepository repository;

  StreamSessionMessagesUsecase(this.repository);

  Stream<DataState<dynamic>> call(String sessionId) {
    return repository.streamSessionMessages(sessionId);
  }
}
