import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/data/datasources/remote/session_messages_remote_datasource.dart';
import 'package:mvmnt_cli/features/support/data/models/session_message_model.dart';
import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';
import 'package:mvmnt_cli/features/support/domain/repository/session_messages_repository.dart';

class SessionMessagesRepositoryImpl extends SessionMessagesRepository {
  final SessionMessagesRemoteDatasource remoteDataSource;

  SessionMessagesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<void>> connect(String sessionId) async {
    try {
      await remoteDataSource.connect(sessionId);
      return DataSuccess(null);
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
  Future<DataState<void>> disconnect() async {
    try {
      await remoteDataSource.disconnect();
      return DataSuccess(null);
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
  Future<DataState<List<SessionMessageEntity>>> loadSessionMessages(
    String sessionId,
  ) async {
    try {
      final result = await remoteDataSource.loadSessionMessages(sessionId);
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
  Future<DataState<SessionMessageEntity>> sendSessionMessage(
    String sessionId,
    MessageContentEntity message,
  ) async {
    try {
      final newMessage = remoteDataSource.sendMessage(
        sessionId,
        MessageContentModel.fromEntity(message),
      );
      return DataSuccess(newMessage);
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
  Stream<DataState<dynamic>> streamSessionMessages(String sessionId) {
    try {
      return remoteDataSource.subscribeToMessages(sessionId).map((event) {
        return DataSuccess(event);
      });
    } catch (e) {
      return Stream.value(
        DataFailed(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: e.toString(),
          ),
        ),
      );
    }
  }
}
