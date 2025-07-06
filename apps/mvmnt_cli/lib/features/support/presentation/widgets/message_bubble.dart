import 'package:flutter/material.dart';
import 'package:mvmnt_cli/core/util/device/device_utility.dart';
import 'package:mvmnt_cli/core/util/formatters/formatter.dart';
import 'package:mvmnt_cli/features/support/domain/entities/session_message_entity.dart';

class SessionMessageBubble extends StatelessWidget {
  final SessionMessageEntity message;

  const SessionMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isUser = message.senderType == SenderType.user;

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: TDeviceUtils.getScreenWidth(context) * 0.75,
          ),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                isUser
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(isUser ? 10 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 10),
            ),
          ),
          child:
              message.content.first.type == MessageContentType.text
                  ? Text(message.content.first.value)
                  : Container(),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 4,
            left: isUser ? 0 : 4,
            right: isUser ? 4 : 0,
            bottom: 16,
          ),
          child: Text(
            '${isUser ? 'Sent at' : 'Received at'} ${TFormatter.formatChatTimestamp(message.createdAt)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
      ],
    );
  }
}
