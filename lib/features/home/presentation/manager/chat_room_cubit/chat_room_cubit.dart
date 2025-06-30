import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/chat_room_repo.dart';
import 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRoomRepo chatRoomRepo;
  StreamSubscription? _subscription;

  ChatRoomCubit(this.chatRoomRepo) : super(ChatRoomInitial());

  Future<void> createChatRoom(String email) async {
    emit(ChatRoomLoading());
    final result = await chatRoomRepo.createChatRoom(email);
    result.fold(
      (failure) => emit(ChatRoomError(failure.message)),
      (_) => emit(ChatRoomSuccess()),
    );
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    emit(ChatRoomLoading());
    final result = await chatRoomRepo.deleteChatRoom(chatRoomId);
    result.fold(
      (failure) => emit(ChatRoomError(failure.message)),
      (_) => emit(ChatRoomSuccess()),
    );
  }

  void listenToUserChatRooms(String userId) {
    emit(ChatRoomLoading());

    _subscription?.cancel();
    _subscription = chatRoomRepo.fetchUserChatRooms(userId: userId).listen((
      either,
    ) {
      either.fold(
        (failure) => emit(ChatRoomError(failure.message)),
        (chatRooms) => emit(ChatRoomListLoaded(chatRooms)),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
