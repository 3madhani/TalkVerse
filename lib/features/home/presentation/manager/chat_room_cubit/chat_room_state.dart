import 'package:equatable/equatable.dart';
import 'package:chitchat/features/home/domain/entities/chat_room_entity.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();

  @override
  List<Object?> get props => [];
}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomSuccess extends ChatRoomState {
  final String message;

  const ChatRoomSuccess(this.message);
}

class ChatRoomError extends ChatRoomState {
  final String message;

  const ChatRoomError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatRoomListLoaded extends ChatRoomState {
  final List<ChatRoomEntity> chatRooms;

  const ChatRoomListLoaded(this.chatRooms);

  @override
  List<Object?> get props => [chatRooms];
}
