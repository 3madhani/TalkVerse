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

  GroupEntity({
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
}
