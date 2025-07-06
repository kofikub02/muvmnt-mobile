import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:mvmnt_cli/features/profile/domain/entities/profile_entity.dart';
import 'package:mvmnt_cli/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepositoryImpl({required this.profileRemoteDataSource});

  @override
  Future<DataState<ProfileEntity>> getProfile() async {
    try {
      final result = await profileRemoteDataSource.getProfile();
      return DataSuccess(result);
    } on DioException catch (error) {
      return DataFailed(error);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<ProfileEntity>> updateProfile(
    String id,
    Map<String, dynamic> profileUpdateEntity,
  ) async {
    try {
      final result = await profileRemoteDataSource.updateProfile(
        id,
        profileUpdateEntity,
      );

      return DataSuccess(result);
    } on DioException catch (error) {
      return DataFailed(error);
    } catch (e) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }
}
