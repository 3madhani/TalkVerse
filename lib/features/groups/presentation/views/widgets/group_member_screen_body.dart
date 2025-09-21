import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/cubits/user_cubit/user_data_cubit.dart';
import '../../../domain/entities/group_entity.dart';
import 'group_members_list_view.dart';

class GroupMemberScreenBody extends StatelessWidget {
  final GroupEntity group;

  final bool isAdmin;
  const GroupMemberScreenBody({
    super.key,
    required this.group,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          BlocBuilder<UserDataCubit, UserDataState>(
            builder: (context, state) {
              if (state is UserDataLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is UsersDataLoaded) {
                final members =
                    state.users
                        .where((user) => group.members.contains(user.uId))
                        .toList();

                return Expanded(
                  child: GroupMembersListView(
                    group: group,
                    members: members,
                    isAdmin: isAdmin,
                  ),
                );
              }
              return const Center(child: Text("Failed to load members"));
            },
          ),
        ],
      ),
    );
  }
}
