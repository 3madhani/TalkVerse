import 'package:chitchat/core/cubits/chat_cubit/chat_message_cubit.dart';
import 'package:chitchat/core/cubits/user_cubit/user_data_cubit.dart';
import 'package:chitchat/core/services/get_it_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            BlocBuilder<UserDataCubit, UserDataState>(
              bloc: getIt<UserDataCubit>(),
              builder: (context, state) {
                if (state is UsersDataLoaded) {
                  List<String> names = [];
                  for (var user in state.users) {
                    names.add(user.name!);
                  }

                  return Text(
                    names.length > 1
                        ? '${names.sublist(0, names.length - 1).join(', ')} and ${names.last}'
                        : names.first,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelLarge,
                  );
                } else if (state is UserDataLoaded) {
                  return Text(
                    '1 member',
                    style: Theme.of(context).textTheme.labelLarge,
                  );
                }
                return const SizedBox.shrink();
              },
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
      widget.group.id,
      BackendEndPoints.groups,
    );
    getIt<UserDataCubit>().loadUserData(usersIds: widget.group.members);
    super.initState();
  }
}
