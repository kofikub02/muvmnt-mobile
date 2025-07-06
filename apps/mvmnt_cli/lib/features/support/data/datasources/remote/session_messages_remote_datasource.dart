import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/socket/socket_client.dart';
import 'package:mvmnt_cli/features/support/data/models/session_message_model.dart';
import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';
import 'package:uuid/uuid.dart';

class SessionMessagesRemoteDatasource {
  final Dio dio;
  final SocketClient socketClient;

  SessionMessagesRemoteDatasource({
    required this.dio,
    required this.socketClient,
  });

  Future<void> connect(String sessionId) async {
    await socketClient.connect(options: {'path': '/orders-socket'});
    socketClient.emit(
      'message',
      jsonEncode({
        'type': 'session_join',
        'data': {'id': sessionId},
      }),
    );
  }

  Future<void> disconnect() async {
    await socketClient.disconnect();
  }

  Future<List<SessionMessageModel>> loadSessionMessages(
    String sessionId,
  ) async {
    final response = await dio.get('/orders/support/$sessionId');

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return (response.data['data'] as List).map((json) {
          return SessionMessageModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      }
    }

    throw response.data['message'];
  }

  SessionMessageModel sendMessage(
    String sessionId,
    MessageContentModel content,
  ) {
    socketClient.emit(
      'message',
      jsonEncode({
        'type': 'session_message',
        'data': {'id': sessionId, 'query': content.value},
      }),
    );

    return SessionMessageModel(
      id: Uuid().v4(),
      content: [content],
      createdAt: DateTime.now(),
      senderType: SenderType.user,
    );
  }

  Stream<dynamic> subscribeToMessages(String sessionId) {
    return socketClient.on('message').map((event) {
      final payload = event.data;

      if (payload['type'] != null &&
          payload['type'] is String &&
          payload['type'].toString().startsWith('session')) {
        return payload;
      }
    });
  }
}
