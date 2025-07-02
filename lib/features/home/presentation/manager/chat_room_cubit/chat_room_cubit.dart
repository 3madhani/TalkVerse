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
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> createChatRoom({required String email}) async {
    emit(ChatRoomLoading());
    final result = await chatRoomRepo.createChatRoom(email);
    result.fold(
      (failure) => emit(ChatRoomError(failure.message)),
      (success) => emit(ChatRoomSuccess(success)),
    );
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    emit(ChatRoomLoading());
    final result = await chatRoomRepo.deleteChatRoom(chatRoomId);
    result.fold(
      (failure) => emit(ChatRoomError(failure.message)),
      (success) => emit(ChatRoomSuccess(success)),
    );
  }

  /// ✅ Load from SharedPreferences on app start
  Future<void> loadCachedChatRooms() async {
    final cachedJson = Prefs.getString('cachedChatRooms');
    if (cachedJson.isNotEmpty) {
      try {
        final List decoded = jsonDecode(cachedJson);
        final cachedRooms =
            decoded
                .map((e) => ChatRoomEntity.fromJson(e))
                .toList()
                .cast<ChatRoomEntity>();

        // 🔽 Sort by lastMessageTime or createdAt
        cachedRooms.sort((a, b) {
          final aTime =
              (a.lastMessageTime != null && a.lastMessageTime!.isNotEmpty)
                  ? DateTime.tryParse(a.lastMessageTime!)
                  : DateTime.tryParse(a.createdAt);

          final bTime =
              (b.lastMessageTime != null && b.lastMessageTime!.isNotEmpty)
                  ? DateTime.tryParse(b.lastMessageTime!)
                  : DateTime.tryParse(b.createdAt);

          return (bTime ?? DateTime(0)).compareTo(aTime ?? DateTime(0));
        });

        chatRoomsCache = cachedRooms;
        emit(ChatRoomListLoaded(cachedRooms));
      } catch (e) {
        emit(const ChatRoomError('Failed to load cached chat rooms.'));
      }
    }
  }

  /// ✅ Used after loading cached data (no loading state if cache is used)
  void listenToUserChatRooms(String userId) async {
    if (chatRoomsCache.isNotEmpty) {
      emit(ChatRoomListLoaded(chatRoomsCache)); // use existing cache
    } else {
      emit(ChatRoomLoading()); // only show loading if no cache
    }

    _subscription?.cancel();
    _subscription = chatRoomRepo.fetchUserChatRooms(userId: userId).listen((
      either,
    ) async {
      await either.fold(
        (failure) async {
          // fallback if stream fails
          emit(ChatRoomError(failure.message));
        },
        (chatRooms) async {
          // 🔽 Sort
          chatRooms.sort((a, b) {
            final aTime =
                (a.lastMessageTime != null && a.lastMessageTime!.isNotEmpty)
                    ? DateTime.tryParse(a.lastMessageTime!)
                    : DateTime.tryParse(a.createdAt);

            final bTime =
                (b.lastMessageTime != null && b.lastMessageTime!.isNotEmpty)
                    ? DateTime.tryParse(b.lastMessageTime!)
                    : DateTime.tryParse(b.createdAt);

            return (bTime ?? DateTime(0)).compareTo(aTime ?? DateTime(0));
          });

          chatRoomsCache = chatRooms;

          final jsonList = chatRooms.map((e) => e.toJson()).toList();
          await Prefs.setString('cachedChatRooms', jsonEncode(jsonList));

          emit(ChatRoomListLoaded(chatRooms));
        },
      );
    });
  }
}
