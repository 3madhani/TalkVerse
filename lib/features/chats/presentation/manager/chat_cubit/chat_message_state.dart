import 'package:equatable/equatable.dart';

import '../../../domain/entities/message_entity.dart';

class ChatMessageFailure extends ChatMessageState {
  final String message;

  const ChatMessageFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessageInitial extends ChatMessageState {}

class ChatMessageLoaded extends ChatMessageState {
  final List<MessageEntity> messages;
  final Set<String> selectedMessageIds;

  const ChatMessageLoaded(this.messages, {this.selectedMessageIds = const {}});

  @override
  List<Object?> get props => [messages, selectedMessageIds];

  List<MessageEntity> get unreadMessages =>
      messages.where((msg) => msg.isRead == false).toList();
}

class ChatMessageLoading extends ChatMessageState {}

abstract class ChatMessageState extends Equatable {
  const ChatMessageState();

  @override
  List<Object?> get props => [];
}
