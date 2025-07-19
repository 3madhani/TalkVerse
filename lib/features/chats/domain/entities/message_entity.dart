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


  MessageEntity copyWith({
    String? messageId,
    String? message,
    String? senderId,
    String? recieverId,
    String? createdAt,
    bool? isRead,
    String? type,
  }) {
    return MessageEntity(
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      recieverId: recieverId ?? this.recieverId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}
