import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/core/cubits/user_cubit/user_data_cubit.dart';
import 'package:chitchat/core/utils/app_date_time.dart';
import 'package:chitchat/core/widgets/dismissible_card.dart';
import 'package:chitchat/features/chats/presentation/views/chat_screen.dart';
import 'package:chitchat/features/groups/domain/entities/group_entity.dart';
import 'package:chitchat/features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import 'package:chitchat/features/groups/presentation/views/group_chat_screen.dart';
import 'package:chitchat/features/home/domain/entities/chat_room_entity.dart';
import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../constants/backend/backend_end_points.dart';
import '../cubits/chat_cubit/chat_message_cubit.dart';
import '../cubits/chat_cubit/chat_message_state.dart';
import '../services/get_it_services.dart';

class UniversalChatCard extends StatefulWidget {
  final ChatRoomEntity? chatRoom;
  final GroupEntity? group;

  const UniversalChatCard({super.key, this.chatRoom, this.group})
    : assert(
        chatRoom != null || group != null,
        'Either chatRoom or group must be provided',
      );

  @override
  State<UniversalChatCard> createState() => _UniversalChatCardState();
}

class _UniversalChatCardState extends State<UniversalChatCard> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  int unreadCount = 0;

  bool get isGroup => widget.group != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create:
          (context) =>
              getIt<ChatMessageCubit>()..fetchMessages(
                isGroup ? widget.group!.id : widget.chatRoom!.id,
                isGroup ? BackendEndPoints.groups : BackendEndPoints.chatRooms,
              ),
      child: BlocListener<ChatMessageCubit, ChatMessageState>(
        listener: (context, state) {
          if (state is ChatMessageLoaded) {
            final messages = state.messages;
            final count =
                messages
                    .where(
                      (msg) => !msg.isRead && msg.senderId != currentUserId,
                    )
                    .length;
            if (unreadCount != count) {
              setState(() => unreadCount = count);
            }
          }
        },
        child: DismissibleCard(
          key: ValueKey(isGroup ? widget.group!.id : widget.chatRoom!.id),
          title: isGroup ? "Delete Group" : "Delete Chat",
          confirm: true,
          id: isGroup ? widget.group!.id : widget.chatRoom!.id,
          content: isGroup ? "group" : "chat",
          onDismiss: _onDismiss,
          child:
              isGroup
                  ? _buildGroupTile(theme)
                  : BlocBuilder<UserDataCubit, UserDataState>(
                    bloc:
                        getIt<UserDataCubit>()..loadUsersData(
                          usersIds: widget.chatRoom?.members ?? [],
                        ),
                    builder: (context, state) {
                      return _buildChatTile(theme, state);
                    },
                  ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String imageUrl, {required bool isGroup}) {
    // Check if imageUrl is valid before trying to load
    final bool hasValidUrl =
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    return CircleAvatar(
      radius: 22,
      child:
          hasValidUrl
              ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                  errorWidget:
                      (context, url, error) => Icon(
                        isGroup ? Icons.group : Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                ),
              )
              : Icon(
                isGroup ? Icons.group : Icons.person,
                size: 30,
                color: Colors.white,
              ),
    );
  }

  Widget _buildChatTile(ThemeData theme, UserDataState state) {
    final chatRoom = widget.chatRoom!;
    UserEntity? user;
    UserEntity? me;

    if (state is UsersDataLoaded && state.users.isNotEmpty) {
      // Use try-catch to avoid type mismatch with orElse
      try {
        user = state.users.firstWhere((u) => u.uId != currentUserId);
      } catch (e) {
        user = null;
      }

      try {
        me = state.users.firstWhere((u) => u.uId == currentUserId);
      } catch (e) {
        me = null;
      }
    }

    if (user == null || user.uId.isEmpty) {
      return const ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text('Loading chat...'),
      );
    }

    final imageUrl = user.photoUrl?.trim() ?? '';
    final subtitle = chatRoom.lastMessage ?? chatRoom.aboutMe;

    return Card(
      elevation: 1,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: {'chatRoom': chatRoom, 'user': user, 'currentUser': me},
          );
        },
        leading: _buildAvatar(imageUrl, isGroup: false),
        title: Text(user.name!, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(color: theme.textTheme.bodySmall?.color),
        ),
        trailing:
            unreadCount > 0
                ? SizedBox(
                  width: 25,
                  height: 25,
                  child: Badge(
                    backgroundColor: theme.colorScheme.primary,
                    label: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                : Text(
                  chatRoom.lastMessageTime != null
                      ? AppDateTime.dateTimeFormat(chatRoom.lastMessageTime!)
                      : '',
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                ),
      ),
    );
  }

  Widget _buildGroupTile(ThemeData theme) {
    final group = widget.group!;
    final imageUrl = group.imageUrl?.trim() ?? '';

    return Card(
      elevation: 1,
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            GroupChatScreen.routeName,
            arguments: group,
          );
        },
        leading: _buildAvatar(imageUrl, isGroup: true),
        title: Text(group.name, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          group.lastMessage.isEmpty ? group.about ?? '' : group.lastMessage,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(color: theme.textTheme.bodySmall?.color),
        ),
        trailing:
            unreadCount > 0
                ? SizedBox(
                  width: 25,
                  height: 25,
                  child: Badge(
                    backgroundColor: theme.colorScheme.primary,
                    label: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                : Text(
                  AppDateTime.dateTimeFormat(group.lastMessageTime),
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                ),
      ),
    );
  }

  // =========================
  // 🧩 Helpers
  // =========================

  Future<void> _onDismiss() async {
    if (isGroup) {
      await getIt<GroupCubit>().deleteGroup(widget.group!.id);
    } else {
      await getIt<ChatRoomCubit>().deleteChatRoom(widget.chatRoom!.id);
    }
  }
}
