import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/shared_preferences_singleton.dart';
import '../../../domain/entities/chat_room_entity.dart';
import '../../../domain/repos/chat_room_repo.dart';
import 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRoomRepo chatRoomRepo;
  StreamSubscription? _subscription;

  List<ChatRoomEntity> chatRoomsCache = [];

  ChatRoomCubit(this.chatRoomRepo) : super(ChatRoomInitial());

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  Future<bool> createChatRoom({required String email}) async {
    emit(ChatRoomLoading());

    final result = await chatRoomRepo.createChatRoom(email);

    bool isSuccess = false;

    result.fold(
      (failure) {
        emit(ChatRoomError(failure.message));
      },
      (message) {
        emit(ChatRoomSuccess(message));
        isSuccess = true;
      },
    );

    return isSuccess;
  }


  Future<void> deleteChatRoom(String roomId) async {
    try {
      await chatRoomRepo.deleteChatRoom(roomId);
      chatRoomsCache.removeWhere((room) => room.id == roomId);
      await _cacheChatRooms(chatRoomsCache);
      emit(ChatRoomListLoaded(List.from(chatRoomsCache)));
      emit(const ChatRoomSuccess("Chat deleted successfully"));
    } catch (e) {
      emit(ChatRoomError("Failed to delete chat: $e"));
    }
  }

  void listenToUserChatRooms(String userId) {
    if (chatRoomsCache.isNotEmpty) {
      emit(ChatRoomListLoaded(chatRoomsCache));
    } else {
      emit(ChatRoomLoading());
    }

    _subscription?.cancel();
    _subscription = chatRoomRepo.fetchUserChatRooms(userId: userId).listen((
      either,
    ) async {
      either.fold((failure) => emit(ChatRoomError(failure.message)), (
        chatRooms,
      ) async {
        chatRoomsCache = _sortChatRooms(chatRooms);
        await _cacheChatRooms(chatRoomsCache);
        emit(ChatRoomListLoaded(chatRoomsCache));
      });
    });
  }

  Future<void> loadCachedChatRooms() async {
    final cachedJson = Prefs.getString('cachedChatRooms');
    if (cachedJson.isEmpty) {
      chatRoomsCache = [];
      emit(ChatRoomListLoaded(chatRoomsCache)); // ✅ Emit empty list
      return;
    }

    try {
      final List<dynamic> decoded = jsonDecode(cachedJson);
      final cachedRooms =
          decoded
              .map((e) => ChatRoomEntity.fromJson(e))
              .cast<ChatRoomEntity>()
              .toList();

      chatRoomsCache = _sortChatRooms(cachedRooms);
      emit(ChatRoomListLoaded(chatRoomsCache));
    } catch (_) {
      emit(const ChatRoomError('Failed to load cached chat rooms'));
    }
  }

  Future<void> _cacheChatRooms(List<ChatRoomEntity> rooms) async {
    final jsonList = rooms.map((e) => e.toJson()).toList();
    await Prefs.setString('cachedChatRooms', jsonEncode(jsonList));
  }

  List<ChatRoomEntity> _sortChatRooms(List<ChatRoomEntity> rooms) {
    DateTime parse(String? value, String fallback) {
      try {
        value ??= fallback;
        return RegExp(r'^\d+\$').hasMatch(value)
            ? DateTime.fromMillisecondsSinceEpoch(int.parse(value))
            : DateTime.parse(value);
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    rooms.sort((a, b) {
      final aTime = parse(a.lastMessageTime, a.createdAt);
      final bTime = parse(b.lastMessageTime, b.createdAt);
      return bTime.compareTo(aTime);
    });

    return rooms;
  }
}
