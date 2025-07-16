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

  void listenToUserChatRooms(String userId) {
    if (chatRoomsCache.isNotEmpty) {
      emit(ChatRoomListLoaded(chatRoomsCache));
    } else {
      emit(ChatRoomLoading());
    }

    _subscription?.cancel();
    _subscription = chatRoomRepo.fetchUserChatRooms(userId: userId).listen((
      either,
    ) {
      either.fold(
        (failure) {
          emit(ChatRoomError(failure.message));
        },
        (chatRooms) async {
          // ✅ Safe date parser
          DateTime parseTime(String? value, String? fallback) {
            value ??= fallback ?? '';
            if (RegExp(r'^\d+$').hasMatch(value)) {
              return DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(value) ?? 0,
              );
            }
            return DateTime.tryParse(value) ??
                DateTime.fromMillisecondsSinceEpoch(0);
          }

          chatRooms.sort((a, b) {
            final aTime = parseTime(a.lastMessageTime, a.createdAt);
            final bTime = parseTime(b.lastMessageTime, b.createdAt);
            return bTime.compareTo(aTime);
          });

          chatRoomsCache = chatRooms;

          final jsonList = chatRooms.map((e) => e.toJson()).toList();
          await Prefs.setString('cachedChatRooms', jsonEncode(jsonList));

          emit(ChatRoomListLoaded(chatRooms));
        },
      );
    });
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

        // ✅ Safe parser: handles both ISO strings and millisecond timestamps
        DateTime parseFlexibleDate(String? value, String fallback) {
          try {
            if (value == null || value.isEmpty) value = fallback;

            if (RegExp(r'^\d+$').hasMatch(value)) {
              return DateTime.fromMillisecondsSinceEpoch(int.parse(value));
            }

            return DateTime.parse(value);
          } catch (_) {
            return DateTime.fromMillisecondsSinceEpoch(0);
          }
        }

        // ✅ Sort by lastMessageTime or createdAt
        cachedRooms.sort((a, b) {
          final aTime = parseFlexibleDate(a.lastMessageTime, a.createdAt);
          final bTime = parseFlexibleDate(b.lastMessageTime, b.createdAt);
          return bTime.compareTo(aTime);
        });

        chatRoomsCache = cachedRooms;
        emit(ChatRoomListLoaded(cachedRooms));
      } catch (e) {
        emit(const ChatRoomError('Failed to load cached chat rooms.'));
      }
    }
  }
}
