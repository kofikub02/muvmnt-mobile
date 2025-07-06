import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/domain/entities/support_session_entity.dart';
import 'package:mvmnt_cli/features/support/domain/repository/support_session_repository.dart';

class GetActiveSessionsUsecase {
  final SupportSessionRepository supportSessionRepository;

  GetActiveSessionsUsecase(this.supportSessionRepository);

  Future<DataState<List<SupportSessionEntity>>> call() {
    return supportSessionRepository.getActiveSessions();
  }
}
