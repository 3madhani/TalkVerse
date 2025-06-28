import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uId,
    required super.email,
    required super.name,
    required super.photoUrl,
    required super.aboutMe,
    required super.createdAt,
    required super.lastSeen,
    required super.pushToken,
    required super.online,
  });

  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      aboutMe: userEntity.aboutMe,
      createdAt: userEntity.createdAt,
      lastSeen: userEntity.lastSeen,
      pushToken: userEntity.pushToken,
      online: userEntity.online,
      uId: userEntity.uId,
      email: userEntity.email,
      name: userEntity.name,
      photoUrl: userEntity.photoUrl,
    );
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      aboutMe: '',
      createdAt: DateTime.now().toIso8601String(),
      lastSeen: DateTime.now().toIso8601String(),
      pushToken: '',
      online: true,
      uId: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      aboutMe: json['aboutMe'],
      createdAt: json['createdAt'],
      lastSeen: json['lastSeen'],
      pushToken: json['pushToken'],
      online: json['online'],
      uId: json['uid'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
    );
  }

  toEntity() => UserEntity(
    uId: uId,
    email: email,
    name: name,
    photoUrl: photoUrl,
    aboutMe: aboutMe,
    createdAt: createdAt,
    lastSeen: lastSeen,
    pushToken: pushToken,
    online: online,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uId;
    data['email'] = email;
    data['name'] = name;
    data['photoUrl'] = photoUrl;
    data['aboutMe'] = aboutMe;
    data['createdAt'] = createdAt;
    data['lastSeen'] = lastSeen;
    data['pushToken'] = pushToken;
    data['online'] = online;
    return data;
  }
}
