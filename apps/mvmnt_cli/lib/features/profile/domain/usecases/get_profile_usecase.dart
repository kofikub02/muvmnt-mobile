import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/profile/domain/entities/profile_entity.dart';
import 'package:mvmnt_cli/features/profile/domain/repository/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository _profileRepository;

  GetProfileUsecase(this._profileRepository);

  Future<DataState<ProfileEntity>> call() {
    return _profileRepository.getProfile();
  }
}
