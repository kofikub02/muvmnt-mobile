import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/domain/entities/support_session_entity.dart';

abstract class SupportSessionRepository {
  Future<DataState<List<SupportSessionEntity>>> getActiveSessions();
  Future<DataState<SupportSessionEntity>> createSession(String orderId);
  Future<DataState<SupportSessionEntity>> endSession();
  Future<DataState<void>> rateSession();
}
