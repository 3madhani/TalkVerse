import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/shared_preferences_singleton.dart';
import '../../../domain/entities/chat_room_entity.dart';
import '../../../domain/repo/chat_room_repo.dart';
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

  Future<void> createChatRoom({required String email}) async {
    emit(ChatRoomLoading());
    final result = await chatRoomRepo.createChatRoom(email);
    result.fold(
      (failure) => emit(ChatRoomError(failure.message)),
      (message) => emit(ChatRoomSuccess(message)),
    );
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    // 1. Optimistically remove the chat room from the local cache
    final updatedCache = List<ChatRoomEntity>.from(chatRoomsCache);
    updatedCache.removeWhere((room) => room.id == chatRoomId);

    // 2. Update the cache and emit new state
    chatRoomsCache = updatedCache;
    await _cacheChatRooms(chatRoomsCache); // ✅ Add this line
    emit(ChatRoomListLoaded(chatRoomsCache));

    // 3. Proceed to delete the chat room from Firestore
    final result = await chatRoomRepo.deleteChatRoom(chatRoomId);

    result.fold(
      (failure) {
        // Optional: Handle failure, maybe re-add the item to the cache
        emit(ChatRoomError(failure.message));
      },
      (message) {
        emit(ChatRoomSuccess(message));
      },
    );
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
    if (cachedJson.isEmpty) return;

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
      emit(const ChatRoomError('Failed to load cached chat rooms.'));
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
        return RegExp(r'^\d+$').hasMatch(value)
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
