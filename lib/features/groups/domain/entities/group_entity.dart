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
    final rawDate = lastMessageTime.isNotEmpty ? lastMessageTime : createdAt;
    if (rawDate.isEmpty) return 'Unknown';

    try {
      DateTime date;
      if (RegExp(r'^\d+$').hasMatch(rawDate)) {
        date = DateTime.fromMillisecondsSinceEpoch(int.parse(rawDate));
      } else {
        date = DateTime.parse(rawDate);
      }

      final now = DateTime.now();
      final localDate = date.toLocal();

      if (now.year == localDate.year &&
          now.month == localDate.month &&
          now.day == localDate.day) {
        return DateFormat('h:mm a').format(localDate);
      }

      final yesterday = now.subtract(const Duration(days: 1));
      if (yesterday.year == localDate.year &&
          yesterday.month == localDate.month &&
          yesterday.day == localDate.day) {
        return 'Yesterday';
      }

      return DateFormat('MMM dd, yyyy').format(localDate);
    } catch (_) {
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
