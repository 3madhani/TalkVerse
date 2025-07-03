import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.messageId,
    required super.message,
    required super.senderId,
    required super.recieverId,
    required super.createdAt,
    required super.isRead,
    required super.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId'] as String,
      message: json['message'] as String,
      senderId: json['senderId'] as String,
      recieverId: json['recieverId'] as String,
      createdAt: json['createdAt'] as String,
      isRead: json['isRead'] as bool,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'message': message,
      'senderId': senderId,
      'recieverId': recieverId,
      'createdAt': createdAt,
      'isRead': isRead,
      'type': type,
    };
  }
}
