class ChatRoomEntity {
  final String id;
  final List<String> members;
  final String lastMessageSender;
  final String lastMessageTime;
  final String lastMessage;
  final String createdAt;

  ChatRoomEntity({
    required this.createdAt,
    required this.id,
    required this.members,
    required this.lastMessageSender,
    required this.lastMessageTime,
    required this.lastMessage,
  });
}
