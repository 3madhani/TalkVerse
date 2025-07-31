import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/backend/backend_end_points.dart';
import '../../../../core/cubits/chat_cubit/chat_message_cubit.dart';
import '../../../../core/cubits/chat_cubit/chat_message_state.dart';
import '../../../../core/services/get_it_services.dart';
import '../../../home/domain/entities/chat_room_entity.dart';
import 'widgets/chat_screen_body.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = 'chat-screen';
  final ChatRoomEntity chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMessageCubit, ChatMessageState>(
      bloc: getIt<ChatMessageCubit>(),
      builder: (context, state) {
        final isSelecting =
            state is ChatMessageLoaded && state.selectedMessageIds.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title:
                isSelecting
                    ? Text('${state.selectedMessageIds.length} selected')
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.chatRoom.roomName),
                        Text(
                          'Last seen at 10:00 am',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
            actions:
                isSelecting
                    ? [
                      IconButton(
                        icon: const Icon(Iconsax.trash),
                        onPressed: () {
                          context.read<ChatMessageCubit>().deleteMessage(
                            collectionPath: BackendEndPoints.chatRooms,
                            receiverId: widget.chatRoom.members.firstWhere(
                              (id) =>
                                  id != FirebaseAuth.instance.currentUser?.uid,
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
                                    (msg) => state.selectedMessageIds.contains(
                                      msg.messageId,
                                    ),
                                  )
                                  .map((msg) => msg.message)
                                  .join('\n'),
                            ),
                          );
                          context.read<ChatMessageCubit>().clearSelection();
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
                          context.read<ChatMessageCubit>().clearSelection();
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
          body: ChatScreenBody(chatRoom: widget.chatRoom),
        );
      },
    );
  }

  @override
  void initState() {
    getIt<ChatMessageCubit>().fetchMessages(
      BackendEndPoints.chatRooms,
      widget.chatRoom.id,
    );
    super.initState();
  }
}
