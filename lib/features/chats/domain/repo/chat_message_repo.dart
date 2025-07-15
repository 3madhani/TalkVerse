import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/message_entity.dart';

abstract class ChatMessageRepo {
  Future<Either<Failure, void>> sendMessage({
    required String receiverId,
    required String message,
    required String roomId,
    String? messageType,
  });

  Future<Either<Failure, void>> deleteMessage({
    required String chatId,
    required String messageId,
  });

  Future<Either<Failure, void>> readMessage({
    required String chatId,
    required String messageId,
    required bool isRead,
  });
  Stream<Either<Failure, List<MessageEntity>>> fetchMessages({
    required String chatId,
    String? lastMessageId,
  });
}