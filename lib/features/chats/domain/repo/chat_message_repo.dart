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

  Stream<Either<Failure, List<MessageEntity>>> fetchMessages({
    required String chatId,
    String? lastMessageId,
  });
}