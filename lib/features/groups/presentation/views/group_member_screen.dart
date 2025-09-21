import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/cubits/user_cubit/user_data_cubit.dart';
import '../../../../core/repos/images_repo/images_repo.dart';
import '../../../../core/repos/user_data_repo/user_data_repo.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repos/group_repo.dart';
import 'group_edit_screen.dart';
import 'widgets/group_member_screen_body.dart';

class GroupMemberScreen extends StatelessWidget {
  static const routeName = '/group-member-screen';
  final GroupEntity group;

  const GroupMemberScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = group.admins.contains(
      FirebaseAuth.instance.currentUser!.uid,
    );
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  GroupCubit(getIt<GroupRepo>())..streamGroup(group.id),
        ),
        BlocProvider(
          create:
              (context) => UserDataCubit(
                imagesRepo: getIt<ImagesRepo>(),
                userDataRepo: getIt<UserDataRepo>(),
              )..loadUsersData(usersIds: group.members),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text.rich(
            TextSpan(
              text: group.name,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: ' Members',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (isAdmin)
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    GroupEditScreen.routeName,
                    arguments: group,
                  );
                },
                icon: const Icon(Iconsax.user_edit),
              ),
          ],
        ),
        body: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GroupError) {
              return Center(child: Text(state.message));
            }
            if (state is GroupLoaded) {
              return GroupMemberScreenBody(
                group: state.group,
                isAdmin: isAdmin,
              );
            }
            return const Center(child: Text("Failed to load members"));
          },
        ),
      ),
    );
  }
}
