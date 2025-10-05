import 'package:dartz/dartz.dart';

import '../../../features/auth/domain/entities/user_entity.dart';
import '../../entities/message_entity.dart';
import '../../errors/failure.dart';

abstract class ChatMessageRepo {
  Future<Either<Failure, void>> deleteMessage({
    required String chatId,
    required List<String> messageId,
    required String collectionPath,
  });

  Stream<Either<Failure, List<MessageEntity>>> fetchMessages({
    required String collectionPath,
    required String chatId,
    String? lastMessageId,
  });

  Future<Either<Failure, void>> readMessage({
    required String chatId,
    required String messageId,
    required bool isRead,
    required String collectionPath,
  });
  Future<Either<Failure, void>> sendMessage({
    required String name,
    List<UserEntity>? users,
    UserEntity? user,
    required String receiverId,
    required String message,
    required String roomId,
    String? messageType,
    required String collectionPath,
  });
}
