import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/core/cubits/user_cubit/user_data_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/backend/backend_end_points.dart';
import '../../../../core/cubits/chat_cubit/chat_message_cubit.dart';
import '../../../../core/cubits/chat_cubit/chat_message_state.dart';
import '../../../../core/services/get_it_services.dart';
import '../../../../core/utils/app_date_time.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../home/domain/entities/chat_room_entity.dart';
import 'widgets/chat_screen_body.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = 'chat-screen';
  final ChatRoomEntity chatRoom;
  final UserEntity? user;
  final UserEntity? currentUser;

  const ChatScreen({
    super.key,
    required this.chatRoom,
    this.user,
    this.currentUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  getIt<ChatMessageCubit>()..fetchMessages(
                    widget.chatRoom.id,
                    BackendEndPoints.chatRooms,
                  ),
        ),
        BlocProvider(
          create:
              (context) =>
                  getIt<UserDataCubit>()
                    ..loadSingleUserData(userId: widget.user!.uId),
        ),
      ],
      child: BlocBuilder<ChatMessageCubit, ChatMessageState>(
        builder: (context, state) {
          final isSelecting =
              state is ChatMessageLoaded && state.selectedMessageIds.isNotEmpty;

          var of = Theme.of(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 2,
              shadowColor: Colors.black26,
              titleSpacing: 0,
              title:
                  isSelecting
                      ? Text(
                        '${state.selectedMessageIds.length} selected messages',
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                clipBehavior: Clip.antiAlias,
                                child: CircleAvatar(
                                  radius: 22,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.user?.photoUrl ?? '',
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
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.chatRoom.roomName,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: of.colorScheme.primary,
                                    ),
                                  ),
                                  BlocBuilder<UserDataCubit, UserDataState>(
                                    builder: (context, state) {
                                      if (state is UserDataLoading) {
                                        return const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.grey,
                                        );
                                      }
                                      if (state is UserDataLoaded) {
                                        return Text(
                                          state.user.online!
                                              ? 'Online'
                                              : "Last seen ${AppDateTime.dateTimeFormat(state.user.lastSeen!)}",
                                          style: of.textTheme.bodySmall!
                                              .copyWith(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
              actions:
                  isSelecting
                      ? [
                        IconButton(
                          icon: const Icon(Iconsax.trash),
                          onPressed: () {
                            getIt<ChatMessageCubit>().deleteMessage(
                              collectionPath: BackendEndPoints.chatRooms,
                              receiverId: widget.chatRoom.members.firstWhere(
                                (id) =>
                                    id !=
                                    FirebaseAuth.instance.currentUser?.uid,
                              ),
                              chatId: widget.chatRoom.id,
                              messageId: state.selectedMessageIds.toList(),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.copy),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: state.messages
                                    .where(
                                      (msg) => state.selectedMessageIds
                                          .contains(msg.messageId),
                                    )
                                    .map((msg) => msg.message)
                                    .join('\n'),
                              ),
                            );
                            getIt<ChatMessageCubit>().clearSelection();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                elevation: 0,
                                width: MediaQuery.sizeOf(context).width * 0.55,
                                padding: const EdgeInsets.all(8),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                content: const Center(
                                  child: Text(
                                    'Messages copied to clipboard',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            getIt<ChatMessageCubit>().clearSelection();
                          },
                        ),
                      ]
                      : [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.more),
                        ),
                      ],
            ),
            body: ChatScreenBody(
              chatRoom: widget.chatRoom,
              user: widget.user!,
              currentUser: widget.currentUser!,
            ),
          );
        },
      ),
    );
  }
}
