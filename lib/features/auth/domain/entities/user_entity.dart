class UserEntity {
  final String uId;
  final String email;
  final String? name;
  final String? photoUrl;

  const UserEntity({
    required this.uId,
    required this.email,
    this.name,
    this.photoUrl,
  });
}
