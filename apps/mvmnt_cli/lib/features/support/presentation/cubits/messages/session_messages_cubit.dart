import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/support/data/models/session_message_model.dart';
import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';
import 'package:mvmnt_cli/features/support/domain/repository/session_messages_repository.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/messages/load_session_messages_usecase.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/messages/send_session_message_usecase.dart';
import 'package:mvmnt_cli/features/support/domain/usecases/messages/stream_session_messages_usecase.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/messages/session_messages_state.dart';

class SessionMessagesCubit extends Cubit<SessionMessagesState> {
  final LoadSessionMessagesUseCase loadSessionMessagesUseCase;
  final SendSessionMessageUseCase sendSessionMessageUseCase;
  final StreamSessionMessagesUsecase streamSessionMessagesUsecase;

  StreamSubscription<DataState<dynamic>>? _messagesStreamSub;

  SessionMessagesCubit({
    required this.loadSessionMessagesUseCase,
    required this.sendSessionMessageUseCase,
    required this.streamSessionMessagesUsecase,
  }) : super(const SessionMessagesState());

  void _listenToMessages(String sessionId) {
    _messagesStreamSub = streamSessionMessagesUsecase(sessionId).listen((
      message,
    ) {
      if (message is DataSuccess) {
        try {
          switch (message.data['type']) {
            case 'session_activity':
              {
                final activityType = message.data['data']['type'];
                if (activityType == 'typing') {
                  emit(state.copyWith(isTyping: true));
                }
                break;
              }
            case 'session_message':
              {
                var newMessage = SessionMessageModel.fromJson(
                  message.data['data'],
                );
                emit(
                  state.copyWith(
                    messages: [newMessage, ...state.messages],
                    isTyping: false,
                  ),
                );
                break;
              }
            default:
              {
                print('${message.data['type']} is not handled');
              }
          }
        } catch (e) {
          emit(
            state.copyWith(
              status: SessionMessagesStatus.error,
              errorMessage: '',
            ),
          );
        }
      }
    });
  }

  Future<void> connectToSession({required String sessionId}) async {
    emit(state.copyWith(status: SessionMessagesStatus.loading));
    final connectionResult = await serviceLocator<SessionMessagesRepository>()
        .connect(sessionId);
    if (connectionResult is DataSuccess) {
      await loadMessages(sessionId);
      _listenToMessages(sessionId);
    } else {
      emit(
        state.copyWith(
          status: SessionMessagesStatus.error,
          errorMessage: connectionResult.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> loadMessages(String sessionId) async {
    emit(state.copyWith(status: SessionMessagesStatus.loading));

    final result = await loadSessionMessagesUseCase(sessionId);

    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: SessionMessagesStatus.loaded,
          messages: result.data,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: SessionMessagesStatus.error,
          errorMessage: result.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> sendMessage(
    String sessionId,
    MessageContentEntity content,
  ) async {
    final result = await sendSessionMessageUseCase(
      sessionId: sessionId,
      message: content,
    );

    if (result is DataSuccess<SessionMessageEntity>) {
      emit(state.copyWith(messages: [result.data!, ...state.messages]));
    } else {
      emit(
        state.copyWith(
          status: SessionMessagesStatus.error,
          errorMessage: result.error?.message ?? '',
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _messagesStreamSub?.cancel();
    await serviceLocator<SessionMessagesRepository>().disconnect();
    return super.close();
  }
}
