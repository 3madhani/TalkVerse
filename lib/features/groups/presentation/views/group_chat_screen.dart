import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/backend/backend_end_points.dart';
import '../../../../core/cubits/chat_cubit/chat_message_cubit.dart';
import '../../../../core/cubits/user_cubit/user_data_cubit.dart';
import '../../../../core/helpers/on_generate_routes.dart';
import '../../../../core/repos/chat_messages_repo/chat_message_repo.dart';
import '../../../../core/repos/images_repo/images_repo.dart';
import '../../../../core/repos/user_data_repo/user_data_repo.dart';
import '../../../../core/services/get_it_services.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repos/group_repo.dart';
import '../cubits/group_cubit/group_cubit.dart';
import 'group_member_screen.dart';
import 'widgets/group_chat_screen_body.dart';

class GroupChatScreen extends StatelessWidget {
  static const routeName = 'group-chat-screen';
  final GroupEntity group;

  const GroupChatScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    var thisGroup = group;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GroupCubit(getIt<GroupRepo>())..streamGroup(group.id),
        ),
        BlocProvider(
          create:
              (_) => ChatMessageCubit(
                getIt<ChatMessageRepo>(),
                getIt<ImagesRepo>(),
              )..fetchMessages(group.id, BackendEndPoints.groups),
        ),
        BlocProvider(
          create:
              (_) => UserDataCubit(
                userDataRepo: getIt<UserDataRepo>(),
                imagesRepo: getIt<ImagesRepo>(),
              )..loadUsersData(usersIds: group.members),
        ),
      ],

      child: Scaffold(
        appBar: AppBar(
          title: BlocConsumer<GroupCubit, GroupState>(
            listener: (context, state) {
              if (state is GroupError) {
                AppSnackBar.showError(context, state.message);
              }
              if (state is GroupLoaded) {
                // refresh members when group is updated
                context.read<UserDataCubit>().loadUsersData(
                  usersIds: state.group.members,
                );
                thisGroup = state.group;
                // refresh group data when there's an update
              }
            },
            builder: (context, state) {
              if (state is GroupLoading) {
                return const CircularProgressIndicator();
              }
              if (state is GroupError) {
                return Text(
                  'Error: ${state.message}',
                  style: const TextStyle(fontSize: 16),
                );
              }
              if (state is GroupLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.group.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    BlocBuilder<UserDataCubit, UserDataState>(
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
                );
              }
              return const SizedBox.shrink();
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  GroupMemberScreen.routeName,
                  arguments: GroupMemberArgs(group: thisGroup),
                );
              },
              icon: const Icon(Iconsax.user),
            ),
          ],
        ),
        body: GroupChatScreenBody(group: thisGroup),
      ),
    );
  }
}
