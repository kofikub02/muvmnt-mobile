import 'package:muvmnt_auth/src/domain/repository/auth_repository.dart';
import 'package:muvmnt_core/muvmnt_core.dart';

class ConfirmEmailVerificationUseCase {
  final AuthRepository repository;

  ConfirmEmailVerificationUseCase(this.repository);

  Future<DataState<bool>> call() async {
    return await repository.confirmEmailVerification();
  }
}
