import 'package:dartz/dartz.dart';

import '../../errors/failure.dart';
import '../../entities/message_entity.dart';

abstract class ChatMessageRepo {
  Future<Either<Failure, void>> sendMessage({
    required String receiverId,
    required String message,
    required String roomId,
    String? messageType,
    required String collectionPath,
  });

  Future<Either<Failure, void>> deleteMessage({
    required String chatId,
    required List<String> messageId,
    required String collectionPath,
  });

  Future<Either<Failure, void>> readMessage({
    required String chatId,
    required String messageId,
    required bool isRead,
    required String collectionPath,
  });
  Stream<Either<Failure, List<MessageEntity>>> fetchMessages({
    required String collectionPath,
    required String chatId,
    String? lastMessageId,
  });
}