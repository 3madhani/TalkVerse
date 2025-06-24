class UserEntity {
  final String uId;
  final String email;
  final String? name;
  final String? username;
  final String? photoUrl;

  const UserEntity({
    required this.uId,
    required this.email,
    this.name,
    this.username,
    this.photoUrl,
  });

  /// Add this getter
  bool get isProfileComplete {
    return name != null &&
        name!.isNotEmpty &&
        username != null &&
        username!.isNotEmpty &&
        photoUrl != null &&
        photoUrl!.isNotEmpty;
  }
}
