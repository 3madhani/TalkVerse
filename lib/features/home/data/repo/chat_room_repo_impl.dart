import 'dart:developer';

import 'package:chitchat/core/constants/backend/backend_end_points.dart';
import 'package:chitchat/core/errors/failure.dart';
import 'package:chitchat/core/services/database_services.dart';
import 'package:chitchat/features/auth/data/model/user_model.dart';
import 'package:chitchat/features/home/data/models/chat_room_model.dart';
import 'package:chitchat/features/home/domain/entities/chat_room_entity.dart';
import 'package:chitchat/features/home/domain/repo/chat_room_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoomRepoImpl implements ChatRoomRepo {
  final DatabaseServices databaseServices;

  ChatRoomRepoImpl({required this.databaseServices});

  @override
  Future<Either<Failure, String>> createChatRoom(String email) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return const Left(ServerFailure("User not logged in"));
      }
      final userId = user.uid;

      final userDataList = await databaseServices.getData(
        path: BackendEndPoints.getUser,
        queryParameters: {"where": "email", "isEqualTo": email},
      );

      if (userDataList == null || userDataList.isEmpty) {
        return const Left(ServerFailure("User not found"));
      }

      final otherUser = UserModel.fromJson(userDataList.first);
      final chatRoomId = _generateChatRoomId(userId, otherUser.uId);

      final exists = await isExist(chatRoomId);
      if (exists) {
        return const Right("Chat room already exists, can't create again");
      }

      final chatRoom = ChatRoomModel(
        roomName: otherUser.name!,
        id: chatRoomId,
        members: [userId, otherUser.uId],
      );

      await databaseServices.setData(
        path: BackendEndPoints.chatRooms,
        data: chatRoom.toJson(),
        documentId: chatRoomId,
      );

      return const Right("Chat room created successfully");
    } catch (e, stackTrace) {
      log("🔥 Error in createChatRoom: $e", stackTrace: stackTrace);
      return const Left(ServerFailure("Failed to create chat room"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteChatRoom(String chatRoomId) async {
    try {
      await databaseServices.deleteData(
        path: BackendEndPoints.chatRooms,
        documentId: chatRoomId,
      );
      return const Right("Chat room deleted successfully");
    } catch (e, stackTrace) {
      log("🔥 Error in deleteChatRoom: $e", stackTrace: stackTrace);
      return const Left(ServerFailure("Failed to delete chat room"));
    }
  }

  @override
  @override
  Stream<Either<Failure, List<ChatRoomEntity>>> fetchUserChatRooms({
    required String userId,
  }) {
    try {
      return databaseServices
          .streamData(
            path: BackendEndPoints.chatRooms,
            queryParameters: {
              "field": "members",
              "arrayContains": userId,
              "orderBy": "lastMessageTime",
              "descending": true,
            },
          )
          .map((dataList) {
            try {
              final chatRooms =
                  (dataList as List)
                      .cast<Map<String, dynamic>>()
                      .map((json) => ChatRoomModel.fromJson(json).toEntity())
                      .toList()
                      .cast<ChatRoomEntity>();

              // ✅ Helper to safely parse both ISO and timestamp strings
              DateTime parseFlexibleDate(String? value, String fallback) {
                try {
                  if (value == null || value.isEmpty) {
                    value = fallback;
                  }

                  // Handle timestamp (e.g. "1751585133279")
                  if (RegExp(r'^\d+$').hasMatch(value)) {
                    return DateTime.fromMillisecondsSinceEpoch(
                      int.parse(value),
                    );
                  }

                  return DateTime.parse(value);
                } catch (_) {
                  return DateTime.fromMillisecondsSinceEpoch(0);
                }
              }

              // ✅ Sort using createdAt or lastMessageTime
              chatRooms.sort((a, b) {
                final aTime = parseFlexibleDate(a.lastMessageTime, a.createdAt);
                final bTime = parseFlexibleDate(b.lastMessageTime, b.createdAt);
                return bTime.compareTo(aTime);
              });

              return Right(chatRooms);
            } catch (e) {
              log("🔥 Error mapping chat rooms: $e");
              return const Left(ServerFailure("Failed to map chat rooms"));
            }
          });
    } catch (e, stackTrace) {
      log("🔥 Error in fetchUserChatRooms: $e", stackTrace: stackTrace);
      return Stream.value(
        const Left(ServerFailure("Failed to fetch chat rooms")),
      );
    }
  }

  Future<bool> isExist(String chatRoomId) async {
    try {
      final chatRoomData = await databaseServices.getData(
        path: BackendEndPoints.chatRooms,
        documentId: chatRoomId,
      );
      return chatRoomData != null && chatRoomData.isNotEmpty;
    } catch (e, stackTrace) {
      log("🔥 Error in isExist: $e", stackTrace: stackTrace);
      return false;
    }
  }

  /// Consistently generate the same chatRoomId for any pair of users
  String _generateChatRoomId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort((a, b) => a.compareTo(b));
    return sorted.join('_');
  }
}
