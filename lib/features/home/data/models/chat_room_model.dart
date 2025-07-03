import '../../domain/entities/chat_room_entity.dart';

class ChatRoomModel {
  String id;
  String roomName;
  List<String> members;
  String? createdAt;
  String? lastMessage;
  String? lastMessageTime;
  String? aboutMe;

  ChatRoomModel({
    this.aboutMe,
    required this.id,
    required this.members,
    this.lastMessage,
    this.lastMessageTime,
    this.createdAt,
    required this.roomName,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      aboutMe: json['aboutMe'],
      roomName: json['roomName'],
      id: json['id'],
      members: List<String>.from(json['members'] ?? []),
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      createdAt: json['createdAt'],
    );
  }

  toEntity() {
    return ChatRoomEntity(
      aboutMe: aboutMe!,
      roomName: roomName,
      id: id,
      members: members,
      lastMessageTime: lastMessageTime,
      lastMessage: lastMessage,
      createdAt: createdAt!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomName': roomName,
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'aboutMe': aboutMe ?? 'Hi, I am using TalkVerse!',
    };
  }
}
