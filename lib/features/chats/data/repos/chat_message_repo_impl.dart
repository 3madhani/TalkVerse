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
  final DatabaseServices databaseServices;
  ChatMessageRepoImpl({required this.databaseServices});

  @override
  Future<Either<Failure, void>> deleteMessage({
    required String chatId,
    required List<String> messageId,
  }) async {
    final path =
        '${BackendEndPoints.chatRooms}/$chatId/${BackendEndPoints.chatMessages}';

    try {
      for (final id in messageId) {
        await databaseServices.deleteData(path: path, documentId: id);
      }

      await _updateCacheAfterDeletion(chatId, messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Delete failed: ${e.toString()}'));
    }
  }

  Future<void> deleteMessagesForChat(String chatId) async {
    await Prefs.remove(_chatCacheKey(chatId));
  }

  @override
  Stream<Either<Failure, List<MessageEntity>>> fetchMessages({
    required String chatId,
    String? lastMessageId,
  }) async* {
    final path =
        '${BackendEndPoints.chatRooms}/$chatId/${BackendEndPoints.chatMessages}';

    try {
      final cachedMessages = await _loadCachedMessages(chatId);
      if (cachedMessages.isNotEmpty) {
        yield Right(cachedMessages);
      }

      final stream = databaseServices.streamData(
        path: path,
        queryParameters: {'orderBy': 'createdAt', 'descending': true},
      );

      await for (final data in stream) {
        if (data is List) {
          final messages = data.map((e) => MessageModel.fromJson(e)).toList();

          final jsonList = data.map((e) => jsonEncode(e)).toList();
          await Prefs.setString(_chatCacheKey(chatId), jsonList.join('||'));

          yield Right(messages);
        } else {
          yield const Left(
            ServerFailure('Unexpected data from Firestore stream.'),
          );
        }
      }
    } catch (e) {
      try {
        final fallback = await _loadCachedMessages(chatId);
        if (fallback.isNotEmpty) {
          yield Right(fallback);
        } else {
          yield Left(ServerFailure('Stream and cache failed: ${e.toString()}'));
        }
      } catch (_) {
        yield const Left(ServerFailure('Failed to decode cached messages.'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> readMessage({
    required String chatId,
    required String messageId,
    required bool isRead,
  }) async {
    try {
      final path =
          '${BackendEndPoints.chatRooms}/$chatId/${BackendEndPoints.chatMessages}/';

      await databaseServices.updateData(
        path: path,
        documentId: messageId,
        data: {'isRead': isRead},
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Read update failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String receiverId,
    required String message,
    required String roomId,
    String? messageType,
  }) async {
    try {
      final path =
          '${BackendEndPoints.chatRooms}/$roomId/${BackendEndPoints.chatMessages}';
      final messageId = const Uuid().v1();
      final messageTime = DateTime.now().millisecondsSinceEpoch.toString();

      final messageModel = MessageModel(
        createdAt: messageTime,
        messageId: messageId,
        message: message,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        recieverId: receiverId,
        isRead: false,
        type: messageType ?? 'text',
      );

      await databaseServices.setData(
        path: path,
        data: messageModel.toJson(),
        documentId: messageId,
      );

      await databaseServices.updateData(
        path: BackendEndPoints.chatRooms,
        documentId: roomId,
        data: {
          'lastMessage': messageType == 'image' ? 'Image' : message,
          'lastMessageTime': messageTime,
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Send failed: ${e.toString()}'));
    }
  }

  String _chatCacheKey(String chatId) => 'cached_chat_messages_$chatId';

  Future<List<MessageModel>> _loadCachedMessages(String chatId) async {
    try {
      final cached = Prefs.getString(_chatCacheKey(chatId));
      if (cached.isEmpty) return [];

      final jsonList = cached.split('||').map((e) => jsonDecode(e)).toList();
      return jsonList.map((e) => MessageModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _updateCacheAfterDeletion(
    String chatId,
    List<String> messageIds,
  ) async {
    final cached = Prefs.getString(_chatCacheKey(chatId));
    if (cached.isEmpty) return;

    try {
      final jsonList = cached.split('||').map((e) => jsonDecode(e)).toList();
      final filtered =
          jsonList
              .where((msg) => !messageIds.contains(msg['messageId']))
              .toList();

      final updatedCache = filtered.map((e) => jsonEncode(e)).join('||');
      await Prefs.setString(_chatCacheKey(chatId), updatedCache);
    } catch (_) {}
  }
}
