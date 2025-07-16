import '../../domain/entities/chat_room_entity.dart';

class ChatRoomModel {
  String id;
  Map<String, String> roomNames; // Map<userId, roomName>
  List<String> members;
  String? createdAt;
  String? lastMessage;
  String? lastMessageTime;
  String? aboutMe;

  ChatRoomModel({
    this.aboutMe,
    required this.id,
    required this.members,
    required this.roomNames,
    this.lastMessage,
    this.lastMessageTime,
    this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      aboutMe: json['aboutMe'],
      id: json['id'],
      members: List<String>.from(json['members'] ?? []),
      roomNames: Map<String, String>.from(json['roomNames'] ?? {}),
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      createdAt: json['createdAt'],
    );
  }

  ChatRoomEntity toEntity(String currentUserId) {
    return ChatRoomEntity(
      aboutMe: aboutMe ?? '',
      roomName: roomNames[currentUserId] ?? 'Unknown',
      id: id,
      members: members,
      lastMessageTime: lastMessageTime,
      lastMessage: lastMessage,
      createdAt: createdAt ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomNames': roomNames,
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'createdAt':
          createdAt ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'aboutMe': aboutMe ?? 'Hi, I am using TalkVerse!',
    };
  }
}
