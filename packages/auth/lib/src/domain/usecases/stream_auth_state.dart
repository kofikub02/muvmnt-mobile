import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/auth/domain/entities/auth_entity.dart';
import 'package:mvmnt_cli/features/auth/domain/repository/auth_repository.dart';

class StreamAuthStateUseCase {
  final AuthRepository _authRepository;

  StreamAuthStateUseCase(this._authRepository);

  Stream<DataState<AuthEntity?>> call({params}) {
    return _authRepository.authChanges.map((entity) {
      return entity;
    });
  }
}
