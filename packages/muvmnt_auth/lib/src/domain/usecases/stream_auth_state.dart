import 'package:muvmnt_auth/src/domain/entities/auth_entity.dart';
import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class StreamAuthStateUseCase {
  final AuthRepository _authRepository;

  StreamAuthStateUseCase(this._authRepository);

  Stream<DataState<AuthEntity?>> call({params}) {
    return _authRepository.authChanges.map((entity) {
      return entity;
    });
  }
}
