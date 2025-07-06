import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';
import 'package:mvmnt_cli/ui/widgets/chat_typing_indicator.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/messages/session_messages_cubit.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/messages/session_messages_state.dart';
import 'package:mvmnt_cli/features/support/presentation/widgets/message_bubble.dart';
import 'package:mvmnt_cli/features/support/presentation/widgets/message_input.dart';

class SupportContactPage extends StatelessWidget {
  final String? sessionId;

  const SupportContactPage({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionMessagesCubit>(
      create: (_) => serviceLocator<SessionMessagesCubit>(),
      child: _SupportContactView(
        key: Key(sessionId ?? 'new_session'),
        sessionId: sessionId,
      ),
    );
  }
}

class _SupportContactView extends StatefulWidget {
  final String? sessionId;

  const _SupportContactView({super.key, this.sessionId});

  @override
  State<_SupportContactView> createState() => _SupportContactViewState();
}

class _SupportContactViewState extends State<_SupportContactView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<SessionMessagesCubit>().connectToSession(
      sessionId: widget.sessionId ?? '',
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() async {
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) {
    context.read<SessionMessagesCubit>().sendMessage(
      widget.sessionId ?? '',
      MessageContentEntity(type: MessageContentType.text, value: message),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Muvmnt Support',
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton(onPressed: () {}, child: Text('End')),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<SessionMessagesCubit, SessionMessagesState>(
                builder: (context, state) {
                  var messages = state.messages;
                  bool isLoading =
                      state.status == SessionMessagesStatus.loading;
                  bool isTyping = state.isTyping;

                  if (isLoading) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: messages.length + (isTyping ? 1 : 0),
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (isTyping && index == 0) {
                        return ChatTypingIndicator();
                      }

                      final messageIndex = isTyping ? index - 1 : index;
                      final message = messages[messageIndex];
                      return SessionMessageBubble(message: message);
                    },
                  );
                },
              ),
            ),

            MessageInput(
              onSend: (message) {
                _sendMessage(message);
              },
            ),
          ],
        ),
      ),
    );
  }
}
