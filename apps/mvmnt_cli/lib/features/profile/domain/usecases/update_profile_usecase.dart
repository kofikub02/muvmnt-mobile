import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/profile/domain/entities/profile_entity.dart';
import 'package:mvmnt_cli/features/profile/domain/repository/profile_repository.dart';

class UpdateProfileUsecase {
  final ProfileRepository _profileRepository;

  UpdateProfileUsecase(this._profileRepository);

  Future<DataState<ProfileEntity>> call({
    String? id,
    Map<String, dynamic>? profileUpdateEntity,
  }) {
    return _profileRepository.updateProfile(id!, profileUpdateEntity!);
  }
}
