import 'package:chitchat/core/cubits/chat_cubit/chat_message_cubit.dart';
import 'package:chitchat/core/cubits/user_cubit/user_data_cubit.dart';
import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/backend/backend_end_points.dart';
import '../../../../core/helpers/on_generate_routes.dart';
import '../../domain/entities/group_entity.dart';
import 'group_member_screen.dart';
import 'widgets/group_chat_screen_body.dart';

class GroupChatScreen extends StatelessWidget {
  static const routeName = 'group-chat-screen';
  final GroupEntity group;

  const GroupChatScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatMessageCubit>(
          create:
              (context) =>
                  getIt<ChatMessageCubit>()
                    ..fetchMessages(group.id, BackendEndPoints.groups),
        ),
        BlocProvider<UserDataCubit>(
          create:
              (context) =>
                  getIt<UserDataCubit>()
                    ..loadUsersData(usersIds: group.members),
        ),
      ],

      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.name, style: Theme.of(context).textTheme.titleLarge),
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
                  } else if (state is UserDataLoading) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(fontSize: 12),
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
                final state = getIt<UserDataCubit>().state;
                List<UserEntity> members = [];
                if (state is UsersDataLoaded) {
                  members = state.users;
                }
                Navigator.pushNamed(
                  context,
                  GroupMemberScreen.routeName,
                  arguments: GroupMemberArgs(group: group, members: members),
                );
              },
              icon: const Icon(Iconsax.user),
            ),
          ],
        ),
        body: GroupChatScreenBody(group: group),
      ),
    );
  }
}
