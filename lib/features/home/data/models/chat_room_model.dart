import '../../domain/entities/chat_room_entity.dart';

class ChatRoomModel {
  String? id;
  List<String>? members;
  String? createdAt;
  String? lastMessage;
  String? lastMessageSender;
  String? lastMessageTime;

  ChatRoomModel({
    this.id,
    this.members,
    this.lastMessage,
    this.lastMessageSender,
    this.lastMessageTime,
    this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'],
      members: List<String>.from(json['members'] ?? []),
      lastMessage: json['lastMessage'],
      lastMessageSender: json['lastMessageSender'],
      lastMessageTime: json['lastMessageTime'],
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
    );
  }

  ChatRoomModel fromEntity(ChatRoomEntity chatRoomEntity) {
    return ChatRoomModel(
      id: chatRoomEntity.id,
      members: chatRoomEntity.members,
      lastMessage: chatRoomEntity.lastMessage,
      lastMessageSender: chatRoomEntity.lastMessageSender,
      lastMessageTime: chatRoomEntity.lastMessageTime,
      createdAt: chatRoomEntity.createdAt,
    );
  }

  toEntity() {
    return ChatRoomEntity(
      id: id ?? '',
      members: members ?? [],
      lastMessageSender: lastMessageSender ?? '',
      lastMessageTime: lastMessageTime ?? '',
      lastMessage: lastMessage ?? '',
      createdAt: createdAt ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'members': members,
      'lastMessage': lastMessage ?? '',
      'lastMessageSender': lastMessageSender,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }
}
