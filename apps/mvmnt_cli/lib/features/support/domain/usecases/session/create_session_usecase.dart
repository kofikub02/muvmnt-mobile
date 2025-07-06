import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/domain/entities/support_session_entity.dart';
import 'package:mvmnt_cli/features/support/domain/repository/support_session_repository.dart';

class CreateSessionUsecase {
  final SupportSessionRepository supportSessionRepository;

  CreateSessionUsecase(this.supportSessionRepository);

  Future<DataState<SupportSessionEntity>> call(String orderId) {
    return supportSessionRepository.createSession(orderId);
  }
}
