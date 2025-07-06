import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/data/datasources/remote/support_session_remote_datasource.dart';
import 'package:mvmnt_cli/features/support/domain/entities/support_session_entity.dart';
import 'package:mvmnt_cli/features/support/domain/repository/support_session_repository.dart';

class SupportSessionRepositoryImpl extends SupportSessionRepository {
  final SupportSessionRemoteDataSource remoteDataSource;

  SupportSessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<SupportSessionEntity>> createSession(String orderId) async {
    try {
      final result = await remoteDataSource.create(orderId);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataFailed(e);
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
  Future<DataState<List<SupportSessionEntity>>> getActiveSessions() async {
    try {
      final result = await remoteDataSource.getAll();
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataFailed(e);
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
  Future<DataState<void>> rateSession() {
    // TODO: implement rateSession
    throw UnimplementedError();
  }

  @override
  Future<DataState<SupportSessionEntity>> endSession() {
    // TODO: implement endSession
    throw UnimplementedError();
  }
}
