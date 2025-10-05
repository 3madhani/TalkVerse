import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/domain/entities/user_entity.dart';
import '../../repos/chat_messages_repo/chat_message_repo.dart';
import '../../repos/images_repo/images_repo.dart';
import 'chat_message_state.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  final ChatMessageRepo chatMessageRepo;
  final ImagesRepo imagesRepo;
  StreamSubscription? _subscription;

  final Set<String> _selectedMessageIds = {};

  ChatMessageCubit(this.chatMessageRepo, this.imagesRepo)
    : super(ChatMessageInitial());

  Set<String> get selectedMessageIds => _selectedMessageIds;

  void clearSelection() {
    if (state is ChatMessageLoaded) {
      final current = state as ChatMessageLoaded;
      _selectedMessageIds.clear();
      emit(ChatMessageLoaded(current.messages, selectedMessageIds: {}));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> deleteMessage({
    required String chatId,
    required String receiverId,
    required List<String> messageId,
    required String collectionPath,
  }) async {
    final result = await chatMessageRepo.deleteMessage(
      collectionPath: collectionPath,
      chatId: chatId,
      messageId: messageId,
    );

    result.fold((failure) => emit(ChatMessageFailure(failure.message)), (_) {
      _selectedMessageIds.clear();
    });
  }

  void fetchMessages(String chatId, String collectionPath) {
    _subscription?.cancel();
    _subscription = chatMessageRepo
        .fetchMessages(chatId: chatId, collectionPath: collectionPath)
        .listen((result) {
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
    required String collectionPath,
    required String messageId,
    required bool isRead,
  }) async {
    final result = await chatMessageRepo.readMessage(
      collectionPath: collectionPath,
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
    required UserEntity user,
    required String roomId,
    required String collectionPath,
    required String receiverId,
    String? message,
    File? image,
    String? messageType,
  }) async {
    if (messageType == 'image') {
      final result = await imagesRepo.uploadImage(image: image!, path: roomId);
      result.fold((failure) => emit(ChatMessageFailure(failure.message)), (
        imageUrl,
      ) async {
        await chatMessageRepo.sendMessage(
          user: user,
          collectionPath: collectionPath,
          roomId: roomId,
          receiverId: receiverId,
          message: imageUrl,
          messageType: messageType,
        );
      });
    } else {
      final result = await chatMessageRepo.sendMessage(
        user: user,
        collectionPath: collectionPath,
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

  void toggleMessageSelection(String id) {
    if (state is ChatMessageLoaded) {
      final current = state as ChatMessageLoaded;
      final selected = Set<String>.from(_selectedMessageIds);

      if (selected.contains(id)) {
        selected.remove(id);
      } else {
        selected.add(id);
      }

      _selectedMessageIds
        ..clear()
        ..addAll(selected);

      emit(ChatMessageLoaded(current.messages, selectedMessageIds: selected));
    }
  }
}
