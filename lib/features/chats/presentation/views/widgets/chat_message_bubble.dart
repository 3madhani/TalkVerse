import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/message_entity.dart';
import '../../manager/chat_cubit/chat_message_cubit.dart';

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
    final backgroundColor =
        widget.isSender
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.secondaryContainer;

    final messageTextColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ChatMessageBubble.horizontalPadding,
        vertical: ChatMessageBubble.verticalPadding,
      ),
      child: Align(
        alignment:
            widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.17,
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(
                    widget.isSender
                        ? 12
                        : widget.message.type == 'text'
                        ? 0
                        : 12,
                  ),
                  bottomRight: Radius.circular(
                    widget.isSender
                        ? widget.message.type == 'text'
                            ? 0
                            : 12
                        : 12,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      widget.message.type == 'text' ? 7 : 4,
                      widget.message.type == 'text' ? 7 : 4,
                      widget.message.type == 'text' ? 8 : 4,
                      widget.message.type == 'text' ? 18 : 4,
                    ),
                    child:
                        widget.message.type == 'text'
                            ? Text(
                              widget.message.message,
                              style: TextStyle(
                                fontSize: 15,
                                color: messageTextColor,
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

                  /// Time and read status
                  Positioned(
                    bottom: 4,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(widget.message.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                widget.message.type == 'text'
                                    ? Colors.grey.shade600
                                    : Colors.black,
                          ),
                        ),
                        if (widget.isSender) ...[
                          const SizedBox(width: 2),
                          Icon(
                            widget.message.isRead
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            size: 13,
                            color:
                                widget.message.type == 'text'
                                    ? widget.message.isRead
                                        ? Colors.green
                                        : Colors.grey.shade600
                                    : widget.message.isRead
                                    ? Colors.green
                                    : Colors.black,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.message.recieverId == FirebaseAuth.instance.currentUser?.uid) {
      context.read<ChatMessageCubit>().readMessage(
        chatId: widget.chatId,
        messageId: widget.message.messageId,
        isRead: true,
      );
    }
    super.initState();
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
