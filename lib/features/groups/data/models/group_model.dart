import '../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.members,
    required super.createdBy,
    required super.createdAt,
    required super.about,
    required super.admins,
    required super.lastMessage,
    required super.lastMessageTime,
  });

  /// Create model from entity
  factory GroupModel.fromEntity(GroupEntity entity) {
    return GroupModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      members: List<String>.from(entity.members),
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      about: entity.about,
      admins: List<String>.from(entity.admins),
      lastMessage: entity.lastMessage,
      lastMessageTime: entity.lastMessageTime,
    );
  }

  /// Create model from JSON
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      members: List<String>.from(json['members'] as List),
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      about: json['about'] as String?,
      admins: List<String>.from(json['admins'] as List),
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: json['lastMessageTime'] as String,
    );
  }

  GroupModel copyWith({
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
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      members: members ?? this.members,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      about: about ?? this.about,
      admins: admins ?? this.admins,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  /// Convert to JSON
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
}
