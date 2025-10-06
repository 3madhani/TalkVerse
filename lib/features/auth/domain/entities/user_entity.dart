import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uId;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? aboutMe;
  final String? createdAt;
  final String? lastSeen;
  final String? pushToken;
  final bool? online;
  final List<String>? friends;

  const UserEntity({
    required this.uId,
    required this.email,
    this.name,
    this.photoUrl,
    this.aboutMe,
    this.createdAt,
    this.lastSeen,
    this.pushToken,
    this.online,
    this.friends,
  });

  @override
  List<Object?> get props => [
    uId,
    email,
    name,
    photoUrl,
    aboutMe,
    createdAt,
    lastSeen,
    pushToken,
    online,
    friends,
  ];

  String formateLastSeen() {
    if (lastSeen == null) return '';

    final date =
        DateTime.fromMillisecondsSinceEpoch(int.parse(lastSeen!)).toLocal();
    return "${date.hour}:${date.minute}";
  }
}
