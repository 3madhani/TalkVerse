// chat_message_cubit.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/shared_preferences_singleton.dart';
import '../../../data/models/message_model.dart';
import '../../../domain/repo/chat_message_repo.dart';
import 'chat_message_state.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  final ChatMessageRepo chatMessageRepo;

  StreamSubscription? _subscription;

  ChatMessageCubit(this.chatMessageRepo) : super(ChatMessageInitial());

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    final result = await chatMessageRepo.deleteMessage(
      chatId: chatId,
      messageId: messageId,
    );

    result.fold(
      (failure) => emit(ChatMessageFailure(failure.message)),
      (_) {}, // fetchMessages will reflect the deletion
    );
  }

  void fetchMessages(String chatId) {
    emit(ChatMessageLoading());

    // Load cached messages first
    final cached = Prefs.getString('cached_chat_messages');
    if (cached.isNotEmpty) {
      try {
        final jsonList = cached.split('||').map((e) => jsonDecode(e)).toList();
        final messages = jsonList.map((e) => MessageModel.fromJson(e)).toList();
        emit(ChatMessageLoaded(messages));
      } catch (_) {
        // ignore cache decoding errors
      }
    }

    _subscription?.cancel(); // Cancel previous subscription

    _subscription = chatMessageRepo.fetchMessages(chatId: chatId).listen((
      result,
    ) {
      result.fold(
        (failure) => emit(ChatMessageFailure(failure.message)),
        (messages) => emit(ChatMessageLoaded(messages)),
      );
    });
  }

  Future<void> sendMessage({
    required String roomId,
    required String receiverId,
    required String message,
  }) async {
    final result = await chatMessageRepo.sendMessage(
      roomId: roomId,
      receiverId: receiverId,
      message: message,
    );

    result.fold(
      (failure) => emit(ChatMessageFailure(failure.message)),
      (_) {}, // no need to emit anything; fetchMessages stream handles updates
    );
  }
}
