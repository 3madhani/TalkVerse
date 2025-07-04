import 'dart:convert';

import 'package:chitchat/core/constants/backend/backend_end_points.dart';
import 'package:chitchat/core/errors/failure.dart';
import 'package:chitchat/core/services/database_services.dart';
import 'package:chitchat/features/chats/data/models/message_model.dart';
import 'package:chitchat/features/chats/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/shared_preferences_singleton.dart';
import '../../domain/repo/chat_message_repo.dart';

class ChatMessageRepoImpl implements ChatMessageRepo {
  static const String _cachedMessagesKey = 'cached_chat_messages';

  final DatabaseServices databaseServices;
  ChatMessageRepoImpl({required this.databaseServices});

  @override
  Future<Either<Failure, void>> deleteMessage({
    required String chatId,
    required String messageId,
  }) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<MessageEntity>>> fetchMessages({
    required String chatId,
    String? lastMessageId,
  }) async* {
    final path =
        '${BackendEndPoints.chatRooms}/$chatId/${BackendEndPoints.chatMessages}';

    try {
      final stream = databaseServices.streamData(
        path: path,
        queryParameters: {'orderBy': 'createdAt', 'descending': true},
      );

      await for (final data in stream) {
        if (data is List) {
          final messages = data.map((e) => MessageModel.fromJson(e)).toList();

          // ✅ Save messages locally to SharedPreferences
          final jsonList = data.map((e) => jsonEncode(e)).toList();
          await Prefs.setString(_cachedMessagesKey, jsonList.join('||'));

          yield Right(messages);
        } else {
          yield const Left(
            ServerFailure('Unexpected data type from Firestore stream.'),
          );
        }
      }
    } catch (e) {
      // On error: try loading from cache
      final cached = Prefs.getString(_cachedMessagesKey);
      if (cached.isNotEmpty) {
        try {
          final jsonList =
              cached.split('||').map((e) => jsonDecode(e)).toList();
          final messages =
              jsonList.map((e) => MessageModel.fromJson(e)).toList();
          yield Right(messages);
        } catch (_) {
          yield const Left(ServerFailure('Failed to decode cached messages.'));
        }
      } else {
        yield Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String receiverId,
    required String message,
    required String roomId,
  }) async {
    try {
      final path =
          '${BackendEndPoints.chatRooms}/$roomId/${BackendEndPoints.chatMessages}';
      final messageId = const Uuid().v1();

      final messageModel = MessageModel(
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        messageId: messageId,
        message: message,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        recieverId: receiverId,
        isRead: false,
        type: 'text',
      );
      await databaseServices.setData(
        path: path,
        data: messageModel.toJson(),
        documentId: messageId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
