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

}
