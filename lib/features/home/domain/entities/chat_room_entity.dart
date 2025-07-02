class ChatRoomEntity {
  final String id;
  final String roomName;
  final List<String> members;
  final String? lastMessageTime;
  final String? lastMessage;
  final String createdAt;
  final String aboutMe;

  ChatRoomEntity({
    required this.aboutMe,
    required this.createdAt,
    required this.id,
    required this.members,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.roomName,
  });
}
