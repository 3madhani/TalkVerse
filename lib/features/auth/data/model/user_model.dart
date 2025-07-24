import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uId,
    required super.email,
    required super.name,
    required super.photoUrl,
    required super.aboutMe,
    required super.createdAt,
    required super.lastSeen,
    required super.pushToken,
    required super.online,
    required super.friends,
  });

  /// Create a UserModel from a UserEntity
  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      uId: userEntity.uId,
      email: userEntity.email,
      name: userEntity.name,
      photoUrl: userEntity.photoUrl,
      aboutMe: userEntity.aboutMe,
      createdAt: userEntity.createdAt,
      lastSeen: userEntity.lastSeen,
      pushToken: userEntity.pushToken,
      online: userEntity.online,
      friends: List<String>.from(userEntity.friends as Iterable),
    );
  }

  /// Create a new user from FirebaseAuth user object (first-time sign-in)
  factory UserModel.fromFirebaseUser(User user) {
    final now = DateTime.now().millisecondsSinceEpoch.toString();

    return UserModel(
      uId: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photoUrl: user.photoURL ?? '',
      aboutMe: '',
      createdAt: now,
      lastSeen: now,
      pushToken: '',
      online: true,
      friends: const [],
    );
  }

  /// Deserialize from Firestore (or JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String,
      aboutMe: json['aboutMe'] as String,
      createdAt: json['createdAt'] as String,
      lastSeen: json['lastSeen'] as String,
      pushToken: json['pushToken'] as String,
      online: json['online'] as bool,
      friends: List<String>.from(json['friends'] ?? []),
    );
  }

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      uId: uId,
      email: email,
      name: name,
      photoUrl: photoUrl,
      aboutMe: aboutMe,
      createdAt: createdAt,
      lastSeen: lastSeen,
      pushToken: pushToken,
      online: online,
      friends: friends,
    );
  }

  /// Convert to Firestore-compatible Map
  Map<String, dynamic> toJson() {
    return {
      'uid': uId,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'aboutMe': aboutMe,
      'createdAt': createdAt,
      'lastSeen': lastSeen,
      'pushToken': pushToken,
      'online': online,
      'friends': friends,
    };
  }
}
