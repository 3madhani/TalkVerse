import 'package:chitchat/features/chats/presentation/views/chat_screen.dart';
import 'package:chitchat/features/groups/domain/entities/group_entity.dart';
import 'package:chitchat/features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import 'package:chitchat/features/groups/presentation/views/group_chat_screen.dart';
import 'package:chitchat/features/home/domain/entities/chat_room_entity.dart';
import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:chitchat/features/home/presentation/views/widgets/dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class UniversalChatCard extends StatelessWidget {
  final ChatRoomEntity? chatRoom;
  final GroupEntity? group;
  final int unreadCount; // pass unread count from outside

  const UniversalChatCard({
    super.key,
    this.chatRoom,
    this.group,
    this.unreadCount = 0,
  }) : assert(
         chatRoom != null || group != null,
         'Either chatRoom or group must be provided',
       );

  bool get isGroup => group != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DismissibleCard(
      title: isGroup ? "Delete Group" : "Delete Chat",
      confirm: true,
      id: isGroup ? group!.id : chatRoom!.id,
      content: isGroup ? "group" : "chat",
      onDismiss: () async {
        if (isGroup) {
          await context.read<GroupCubit>().deleteGroup(group!.id);
        } else {
          await context.read<ChatRoomCubit>().deleteChatRoom(chatRoom!.id);
        }
      },
      child: Card(
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
                arguments: group,
              );
            } else {
              Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: chatRoom,
              );
            }
          },
          leading: CircleAvatar(
            radius: 22,
            child: isGroup ? Text(group!.name[0]) : const Icon(Iconsax.user),
          ),
          title: Text(
            isGroup ? group!.name : chatRoom!.roomName,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            isGroup
                ? (group!.lastMessage.isEmpty
                    ? group!.about ?? ''
                    : group!.lastMessage)
                : (chatRoom!.lastMessage ?? chatRoom!.aboutMe),
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
                        ? group!.formatDateAndTime()
                        : chatRoom!.formatDateAndTime(),
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
        ),
      ),
    );
  }
}
