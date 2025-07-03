import 'package:equatable/equatable.dart';
import '../../../domain/entities/message_entity.dart';

abstract class ChatMessageState extends Equatable {
  const ChatMessageState();

  @override
  List<Object?> get props => [];
}

class ChatMessageInitial extends ChatMessageState {}

class ChatMessageLoading extends ChatMessageState {}

class ChatMessageLoaded extends ChatMessageState {
  final List<MessageEntity> messages;

  const ChatMessageLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatMessageFailure extends ChatMessageState {
  final String message;

  const ChatMessageFailure(this.message);

  @override
  List<Object?> get props => [message];
}
