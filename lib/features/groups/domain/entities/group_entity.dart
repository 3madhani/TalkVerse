import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class GroupEntity extends Equatable {
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

  /// Immutable update helper
  GroupEntity copyWith({
    String? id,
    String? name,
    String? imageUrl,
    List<String>? members,
    String? createdBy,
    String? createdAt,
    String? about,
    List<String>? admins,
    String? lastMessage,
    String? lastMessageTime,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      members: members ?? List<String>.from(this.members),
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      about: about ?? this.about,
      admins: admins ?? List<String>.from(this.admins),
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  /// Format date & time for UI
  String formatDateAndTime() {
    final rawDate = (lastMessageTime.isNotEmpty) ? lastMessageTime : createdAt;

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
        return DateFormat('h:mm a').format(localDate);
      } else if (isYesterday) {
        return 'Yesterday';
      } else {
        return DateFormat('MMM dd, yyyy').format(localDate);
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

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    members,
    createdBy,
    createdAt,
    about,
    admins,
    lastMessage,
    lastMessageTime,
  ];
}
