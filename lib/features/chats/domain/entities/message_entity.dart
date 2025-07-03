class MessageEntity {
  final String messageId;
  final String message;
  final String senderId;
  final String recieverId;
  final String createdAt;
  final bool isRead;
  final String type;

  MessageEntity({
    required this.messageId,
    required this.message,
    required this.senderId,
    required this.recieverId,
    required this.createdAt,
    required this.isRead,
    required this.type,
  });
}
