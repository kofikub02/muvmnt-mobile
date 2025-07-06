import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';

abstract class SessionMessagesRepository {
  Future<DataState<void>> connect(String sessionId);
  Future<DataState<List<SessionMessageEntity>>> loadSessionMessages(
    String sessionId,
  );
  Future<DataState<SessionMessageEntity>> sendSessionMessage(
    String sessionId,
    MessageContentEntity message,
  );
  Stream<DataState<dynamic>> streamSessionMessages(String sessionId);
  Future<DataState<void>> disconnect();
}
