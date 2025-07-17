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

  String formatDateAndTime() {
    final rawDate =
        (lastMessageTime != null && lastMessageTime!.isNotEmpty)
            ? lastMessageTime
            : createdAt;

    if (rawDate == null || rawDate.isEmpty) return 'Unknown';

    try {
      DateTime date;

      // Check if it's a numeric timestamp (millisecondsSinceEpoch)
      if (RegExp(r'^\d+$').hasMatch(rawDate)) {
        date = DateTime.fromMillisecondsSinceEpoch(int.parse(rawDate));
      } else {
        date = DateTime.parse(rawDate);
      }

      final now = DateTime.now();
      final localDate = date.toLocal();

      final isToday =
          now.year == localDate.year &&
          now.month == localDate.month &&
          now.day == localDate.day;

      final yesterday = now.subtract(const Duration(days: 1));
      final isYesterday =
          yesterday.year == localDate.year &&
          yesterday.month == localDate.month &&
          yesterday.day == localDate.day;

      if (isToday) {
        return DateFormat('h:mm a').format(localDate); // ➜ 3:45 PM
      } else if (isYesterday) {
        return 'Yesterday';
      } else {
        return DateFormat('MMM dd, yyyy').format(localDate); // ➜ Jul 02, 2025
      }
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
