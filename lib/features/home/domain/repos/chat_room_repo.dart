import 'package:chitchat/core/errors/failure.dart';
import 'package:chitchat/features/home/domain/entities/chat_room_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRoomRepo {
  Future<Either<Failure, String>> createChatRoom(String email);
  Future<Either<Failure, String>> deleteChatRoom(String chatRoomId);

  Stream<Either<Failure, List<ChatRoomEntity>>> fetchUserChatRooms();

}
