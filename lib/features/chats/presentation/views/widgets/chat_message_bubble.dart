import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../domain/entities/message_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isSender;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isSender
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.secondaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
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
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isSender ? 16 : 0),
                  bottomRight: Radius.circular(isSender ? 0 : 16),
                ),
              ),
              child: Stack(
                children: [
                  /// Message text with padding for time
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 12,
                      bottom: 22,
                    ),
                    child: Text(
                      message.message,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),

                  /// Time and read icon at bottom-right
                  Positioned(
                    bottom: 6,
                    right: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.createdAt),
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        if (isSender)
                          Icon(
                            message.isRead
                                ? Iconsax.tick_circle5
                                : Iconsax.tick_circle,
                            size: 16,
                            color: message.isRead ? Colors.blue : Colors.grey,
                          ),
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

  String _formatTime(dynamic dateInput) {
    try {
      DateTime date;

      // Case 1: Timestamp in milliseconds (as int or string)
      if (dateInput is int) {
        date = DateTime.fromMillisecondsSinceEpoch(dateInput).toLocal();
      } else if (dateInput is String && RegExp(r'^\d+$').hasMatch(dateInput)) {
        date =
            DateTime.fromMillisecondsSinceEpoch(int.parse(dateInput)).toLocal();
      }
      // Case 2: ISO 8601 string
      else if (dateInput is String) {
        date = DateTime.parse(dateInput).toLocal();
      } else {
        return '';
      }

      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (_) {
      return '';
    }
  }
}
