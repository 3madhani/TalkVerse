import 'package:chitchat/core/errors/failure.dart';
import 'package:chitchat/features/home/domain/entities/chat_room_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRoomRepo {
  Future<Either<Failure, void>> createChatRoom(String email);
  Future<Either<Failure, void>> deleteChatRoom(String chatRoomId);

  Stream<Either<Failure, List<ChatRoomEntity>>> fetchUserChatRooms({
    required String userId,
  });

}
