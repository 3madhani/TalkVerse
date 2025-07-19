import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/images_repo/images_repo.dart';
import '../../../../../core/services/shared_preferences_singleton.dart';
import '../../../data/models/message_model.dart';
import '../../../domain/repo/chat_message_repo.dart';
import 'chat_message_state.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  final ChatMessageRepo chatMessageRepo;
  final ImagesRepo imagesRepo;
  StreamSubscription? _subscription;

  ChatMessageCubit(this.chatMessageRepo, this.imagesRepo)
    : super(ChatMessageInitial());

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
    result.fold((failure) => emit(ChatMessageFailure(failure.message)), (_) {});
  }

  void fetchMessages(String chatId) {
    emit(ChatMessageLoading());

    final cached = Prefs.getString('cached_chat_messages');
    if (cached.isNotEmpty) {
      try {
        final jsonList = cached.split('||').map((e) => jsonDecode(e)).toList();
        final messages = jsonList.map((e) => MessageModel.fromJson(e)).toList();
        emit(ChatMessageLoaded(messages));
      } catch (_) {}
    }

    _subscription?.cancel();
    _subscription = chatMessageRepo.fetchMessages(chatId: chatId).listen((
      result,
    ) {
      result.fold(
        (failure) => emit(ChatMessageFailure(failure.message)),
        (messages) => emit(ChatMessageLoaded(messages)),
      );
    });
  }

  void markMessageAsReadLocally(String messageId) {
    final currentState = state;
    if (currentState is ChatMessageLoaded) {
      final updatedMessages =
          currentState.messages.map((msg) {
            if (msg.messageId == messageId) {
              return msg.copyWith(isRead: true);
            }
            return msg;
          }).toList();
      emit(ChatMessageLoaded(updatedMessages));
    }
  }

  Future<void> readMessage({
    required String chatId,
    required String messageId,
    required bool isRead,
  }) async {
    final result = await chatMessageRepo.readMessage(
      chatId: chatId,
      messageId: messageId,
      isRead: isRead,
    );
    result.fold(
      (failure) => emit(ChatMessageFailure(failure.message)),
      (_) => markMessageAsReadLocally(messageId),
    );
  }

  Future<void> sendMessage({
    required String roomId,
    required String receiverId,
    String? message,
    File? image,
    String? messageType,
  }) async {
    emit(ChatMessageLoading());

    if (messageType == 'image') {
      final result = await imagesRepo.uploadImage(image: image!, path: roomId);
      result.fold((failure) => emit(ChatMessageFailure(failure.message)), (
        imageUrl,
      ) async {
        await chatMessageRepo.sendMessage(
          roomId: roomId,
          receiverId: receiverId,
          message: imageUrl,
          messageType: messageType,
        );
      });
    } else {
      final result = await chatMessageRepo.sendMessage(
        roomId: roomId,
        receiverId: receiverId,
        message: message!,
        messageType: messageType,
      );
      result.fold(
        (failure) => emit(ChatMessageFailure(failure.message)),
        (_) {},
      );
    }
  }
}