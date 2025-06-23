import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uId,
    required super.email,
    required super.name,
    required super.photoUrl,
  });

  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      uId: userEntity.uId,
      email: userEntity.email,
      name: userEntity.name,
      photoUrl: userEntity.photoUrl,
    );
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uId: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uid'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
    );
  }

  toEntity() =>
      UserEntity(uId: uId, email: email, name: name, photoUrl: photoUrl);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uId;
    data['email'] = email;
    data['name'] = name;
    data['photoUrl'] = photoUrl;
    return data;
  }
}
