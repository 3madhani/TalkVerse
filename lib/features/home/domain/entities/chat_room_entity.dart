import 'package:intl/intl.dart';

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

  factory ChatRoomEntity.fromJson(Map<String, dynamic> json) {
    return ChatRoomEntity(
      aboutMe: json['aboutMe'],
      roomName: json['roomName'],
      id: json['id'],
      members: List<String>.from(json['members']),
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      createdAt: json['createdAt'],
    );
  }

String formatDate() {
    final rawDate =
        (lastMessageTime != null && lastMessageTime!.isNotEmpty)
            ? lastMessageTime
            : createdAt;

    try {
      final date = DateTime.parse(rawDate!).toLocal();
      return DateFormat('MMM dd, yyyy').format(date); // ➜ Jul 02, 2025
    } catch (e) {
      return 'Unknown';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomName': roomName,
      'members': members,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
      'aboutMe': aboutMe,
    };
  }
}
