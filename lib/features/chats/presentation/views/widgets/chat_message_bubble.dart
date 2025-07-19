import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/message_entity.dart';
import '../../manager/chat_cubit/chat_message_cubit.dart';
import '../../manager/chat_cubit/chat_message_state.dart';

class ChatMessageBubble extends StatelessWidget {
  static const double horizontalPadding = 8.0;
  static const double verticalPadding = 4.0;

  final MessageEntity message;
  final String chatId;
  final bool isSender;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.watch<ChatMessageCubit>();
    final state = cubit.state;

    final isText = message.type == 'text';
    final isSelected =
        state is ChatMessageLoaded &&
        state.selectedMessageIds.contains(message.messageId);

    return GestureDetector(
      onLongPress: () {
        cubit.toggleMessageSelection(message.messageId);
      },
      onTap: () {
        if (cubit.selectedMessageIds.isNotEmpty) {
          cubit.toggleMessageSelection(message.messageId);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          borderRadius: _bubbleBorderRadius(isSender, isText),
          color:
              isSelected
                  ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                  : Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.17,
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      isSender
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.secondaryContainer,
                  borderRadius: _bubbleBorderRadius(isSender, isText),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        isText ? 7 : 4,
                        isText ? 7 : 4,
                        isText ? 8 : 4,
                        isText ? 18 : 4,
                      ),
                      child:
                          isText
                              ? Text(
                                message.message,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 15,
                                  color:
                                      theme.textTheme.bodyMedium?.color ??
                                      Colors.black,
                                ),
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: message.message,
                                  fit: BoxFit.cover,
                                  errorWidget:
                                      (context, url, error) => const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                ),
                              ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 8,
                      child: _buildTimeAndStatus(theme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _bubbleBorderRadius(bool isSender, bool isText) {
    return BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isSender || !isText ? 12 : 0),
      bottomRight: Radius.circular(!isSender || !isText ? 12 : 0),
    );
  }

  Widget _buildTimeAndStatus(ThemeData theme) {
    final timeColor =
        message.type == 'text' ? Colors.grey.shade600 : Colors.black;
    final iconColor =
        message.isRead
            ? Colors.green
            : message.type == 'text'
            ? Colors.grey.shade600
            : Colors.black;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.createdAt),
          style: theme.textTheme.labelSmall?.copyWith(color: timeColor),
        ),
        if (isSender) ...[
          const SizedBox(width: 2),
          Icon(
            message.isRead ? Icons.check_circle : Icons.check_circle_outline,
            size: 13,
            color: iconColor,
          ),
        ],
      ],
    );
  }

  String _formatTime(dynamic dateInput) {
    try {
      DateTime date;

      if (dateInput is int) {
        date = DateTime.fromMillisecondsSinceEpoch(dateInput).toLocal();
      } else if (dateInput is String && RegExp(r'^\d+$').hasMatch(dateInput)) {
        date =
            DateTime.fromMillisecondsSinceEpoch(int.parse(dateInput)).toLocal();
      } else if (dateInput is String) {
        date = DateTime.parse(dateInput).toLocal();
      } else {
        return '';
      }

      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
