import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<DataState<ProfileEntity>> getProfile();
  Future<DataState<ProfileEntity>> updateProfile(
    String id,
    Map<String, dynamic> update,
  );
}
