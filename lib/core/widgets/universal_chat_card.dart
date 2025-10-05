import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/core/cubits/user_cubit/user_data_cubit.dart';
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

    return BlocListener<ChatMessageCubit, ChatMessageState>(
      bloc: getIt<ChatMessageCubit>(),
      listener: (context, state) {
        if (state is ChatMessageLoaded) {
          final messages = state.messages;
          unreadCount =
              messages
                  .where(
                    (message) =>
                        message.isRead == false &&
                        message.senderId != currentUserId,
                  )
                  .length;
          setState(() {});
        }
      },
      child: DismissibleCard(
        title: isGroup ? "Delete Group" : "Delete Chat",
        confirm: true,
        id: isGroup ? widget.group!.id : widget.chatRoom!.id,
        content: isGroup ? "group" : "chat",
        onDismiss: () async {
          if (isGroup) {
            await getIt<GroupCubit>().deleteGroup(widget.group!.id);
          } else {
            await getIt<ChatRoomCubit>().deleteChatRoom(widget.chatRoom!.id);
          }
        },
        child: BlocBuilder<UserDataCubit, UserDataState>(
          bloc:
              getIt<UserDataCubit>()
                ..loadUsersData(usersIds: widget.chatRoom?.members ?? []),
          builder: (context, state) {
            UserEntity? user;
            UserEntity? me;
            if (state is UsersDataLoaded) {
              user = state.users.firstWhere(
                (element) => element.uId != currentUserId,
              );
              me = state.users.firstWhere(
                (element) => element.uId == currentUserId,
              );
            }

            return Card(
              elevation: 1,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  if (isGroup) {
                    Navigator.pushNamed(
                      context,
                      GroupChatScreen.routeName,
                      arguments: widget.group,
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      ChatScreen.routeName,
                      arguments: {
                        'chatRoom': widget.chatRoom,
                        'user': user,
                        "currentUser": me,
                      },
                    );
                  }
                },
                leading: CircleAvatar(
                  radius: 22,
                  child:
                      isGroup
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: widget.group!.imageUrl ?? '',
                              placeholder:
                                  (context, url) =>
                                      const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.grey,
                                      ),
                              errorWidget:
                                  (context, url, error) => const Icon(
                                    Icons.group,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                            ),
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: user!.photoUrl ?? '',
                              placeholder:
                                  (context, url) =>
                                      const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.grey,
                                      ),
                              errorWidget:
                                  (context, url, error) => const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                ),
                title: Text(
                  isGroup ? widget.group!.name : widget.chatRoom!.roomName,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  isGroup
                      ? (widget.group!.lastMessage.isEmpty
                          ? widget.group!.about ?? ''
                          : widget.group!.lastMessage)
                      : (widget.chatRoom!.lastMessage ??
                          widget.chatRoom!.aboutMe),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: theme.textTheme.bodySmall?.color),
                ),
                trailing:
                    !isGroup && unreadCount > 0
                        ? SizedBox(
                          width: 25,
                          height: 25,
                          child: Badge(
                            backgroundColor: theme.colorScheme.primary,
                            label: Text(
                              '$unreadCount',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                        : Text(
                          isGroup
                              ? widget.group!.formatDateAndTime()
                              : widget.chatRoom!.formatDateAndTime(),
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.chatRoom != null) {
      getIt<ChatMessageCubit>().fetchMessages(
        widget.chatRoom!.id,
        BackendEndPoints.chatRooms,
      );
    } else if (widget.group != null) {
      getIt<ChatMessageCubit>().fetchMessages(
        widget.group!.id,
        BackendEndPoints.groups,
      );
    }
    super.initState();
  }
}
