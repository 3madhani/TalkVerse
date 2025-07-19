import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/message_entity.dart';
import '../../manager/chat_cubit/chat_message_cubit.dart';
import '../../manager/chat_cubit/chat_message_state.dart';

class ChatMessageBubble extends StatefulWidget {
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
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.watch<ChatMessageCubit>();
    final state = cubit.state;

    final isText = widget.message.type == 'text';
    final isSelected =
        state is ChatMessageLoaded &&
        state.selectedMessageIds.contains(widget.message.messageId);

    return GestureDetector(
      onLongPress: () {
        cubit.toggleMessageSelection(widget.message.messageId);
      },
      onTap: () {
        if (cubit.selectedMessageIds.isNotEmpty) {
          cubit.toggleMessageSelection(widget.message.messageId);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          borderRadius: _bubbleBorderRadius(widget.isSender, isText),
          color:
              isSelected
                  ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                  : Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ChatMessageBubble.horizontalPadding,
            vertical: ChatMessageBubble.verticalPadding,
          ),
          alignment:
              widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.17,
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      widget.isSender
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.secondaryContainer,
                  borderRadius: _bubbleBorderRadius(widget.isSender, isText),
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
                                widget.message.message,
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
                                  imageUrl: widget.message.message,
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

  @override
  void initState() {
    context.read<ChatMessageCubit>().readMessage(
      chatId: widget.chatId,
      messageId: widget.message.messageId,
      isRead: true,
    );
    super.initState();
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
        widget.message.type == 'text' ? Colors.grey.shade600 : Colors.black;
    final iconColor =
        widget.message.isRead
            ? Colors.green
            : widget.message.type == 'text'
            ? Colors.grey.shade600
            : Colors.black;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(widget.message.createdAt),
          style: theme.textTheme.labelSmall?.copyWith(color: timeColor),
        ),
        if (widget.isSender) ...[
          const SizedBox(width: 2),
          Icon(
            widget.message.isRead
                ? Icons.check_circle
                : Icons.check_circle_outline,
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
