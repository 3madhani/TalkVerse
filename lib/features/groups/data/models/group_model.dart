import 'package:intl/intl.dart';

import '../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.members,
    required super.createdBy,
    required super.createdAt,
    required super.about,
    required super.admins,
    required super.lastMessage,
    required super.lastMessageTime,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      members: List<String>.from(json['members'] as List),
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      about: json['about'] as String?,
      admins: List<String>.from(json['admins'] as List),
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: json['lastMessageTime'] as String,
    );
  }

  String formatDateAndTime() {
    final rawDate = (lastMessageTime.isNotEmpty) ? lastMessageTime : createdAt;

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
