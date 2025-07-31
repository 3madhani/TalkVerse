import 'package:intl/intl.dart';

class GroupEntity {
  final String id;
  final String name;
  final String? imageUrl;
  final List<String> members;
  final String createdBy;
  final String createdAt;
  final String? about;
  final List<String> admins;
  final String lastMessage;
  final String lastMessageTime;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.members,
    required this.createdBy,
    required this.createdAt,
    required this.about,
    required this.admins,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory GroupEntity.fromJson(Map<String, dynamic> json) {
    return GroupEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      members: List<String>.from(json['members'] as List),
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      about: json['about'] as String?,
      admins: List<String>.from(json['admins'] as List),
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageTime: json['lastMessageTime'] as String? ?? '',
    );
  }

  /// Format date & time for UI
String formatDateAndTime() {
    final rawDate =
        (lastMessageTime.isNotEmpty)
            ? lastMessageTime
            : createdAt;

    if (rawDate.isEmpty) return 'Unknown';

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
      'name': name,
      'imageUrl': imageUrl,
      'members': members,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'about': about,
      'admins': admins,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}
