import 'package:chitchat/core/widgets/universal_chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../domain/entities/group_entity.dart';
import '../../cubits/group_cubit/group_cubit.dart';

class GroupsScreenBody extends StatelessWidget {
  const GroupsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is GroupError) {
          AppSnackBar.showError(context, state.message);
        } else if (state is GroupSuccess) {
          if (state.message.contains("already exists")) {
            AppSnackBar.showWarning(context, state.message);
          } else {
            AppSnackBar.showSuccess(context, state.message);
          }
        }
      },
      builder: (context, state) {
        final groupCubit = context.read<GroupCubit>();
        final cachedGroups = groupCubit.groupsCache;

        // Skeleton loading if no cache yet
        if (state is GroupLoading && cachedGroups.isEmpty) {
          return Skeletonizer(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: UniversalChatCard(
                    group: GroupEntity(
                      imageUrl: '',
                      id: '',
                      name: 'Loading...',
                      createdAt: '',
                      lastMessageTime: '',
                      members: [],
                      lastMessage: '',
                      about: '',
                      admins: [],
                      createdBy: '',
                    ),
                  ),
                );
              },
            ),
          );
        }

        // Decide which list to show
        final groups = state is GroupLoaded ? state.groups : cachedGroups;

        if (groups.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return UniversalChatCard(group: groups[index]);
            },
          );
        }

        // Empty state
        return const Center(
          child: Text(
            'You have no groups yet\nCreate one to start chatting!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
