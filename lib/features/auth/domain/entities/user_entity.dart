class UserEntity {
  final String uId;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? aboutMe;
  final String? createdAt;
  final String? lastSeen;
  final String? pushToken;
  final bool? online;

  const UserEntity({
    this.aboutMe,
    this.createdAt,
    this.lastSeen,
    this.pushToken,
    this.online,
    required this.uId,
    required this.email,
    this.name,
    this.photoUrl,
  });
}
