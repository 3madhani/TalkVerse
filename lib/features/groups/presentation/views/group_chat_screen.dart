import 'package:chitchat/core/cubits/chat_cubit/chat_message_cubit.dart';
import 'package:chitchat/core/services/get_it_services.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/backend/backend_end_points.dart';
import '../../domain/entities/group_entity.dart';
import 'group_member_screen.dart';
import 'widgets/group_chat_screen_body.dart';

class GroupChatScreen extends StatefulWidget {
  static const routeName = 'group-chat-screen';
  final GroupEntity group;

  const GroupChatScreen({super.key, required this.group});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              widget.group.about ?? 'No description',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, GroupMemberScreen.routeName);
            },
            icon: const Icon(Iconsax.user),
          ),
        ],
      ),
      body: GroupChatScreenBody(group: widget.group),
    );
  }

  @override
  void initState() {
    getIt<ChatMessageCubit>().fetchMessages(
      BackendEndPoints.groups,
      widget.group.id,
    );
    super.initState();
  }
}
