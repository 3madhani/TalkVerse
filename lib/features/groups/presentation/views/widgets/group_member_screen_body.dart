import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/cubits/user_cubit/user_data_cubit.dart';
import '../../../domain/entities/group_entity.dart';
import 'group_members_list_view.dart';

class GroupMemberScreenBody extends StatelessWidget {
  final GroupEntity group;

  const GroupMemberScreenBody({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UsersDataLoaded) {
          final members =
              state.users
                  .where((user) => group.members.contains(user.uId))
                  .toList();

          if (members.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No members found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GroupMembersListView(group: group, members: members),
          );
        }

        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Failed to load members',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }
}
