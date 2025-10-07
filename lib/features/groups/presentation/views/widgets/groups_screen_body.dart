import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/core/widgets/universal_chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/widgets/app_snack_bar.dart';
import '../../cubits/group_cubit/group_cubit.dart';

class GroupsScreenBody extends StatefulWidget {
  const GroupsScreenBody({super.key});

  @override
  State<GroupsScreenBody> createState() => _GroupsScreenBodyState();
}

class _GroupsScreenBodyState extends State<GroupsScreenBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      bloc: getIt<GroupCubit>(),
      listener: (context, state) {
        if (state is GroupError) {
          AppSnackBar.showError(context, state.message);
        } else if (state is GroupSuccess) {
          AppSnackBar.showSuccess(context, state.message);
        }
      },
      builder: (context, state) {
        final groupCubit = getIt<GroupCubit>();
        final cachedGroups = groupCubit.groupsCache;

        // Skeleton loading when no cached data yet
        if (state is GroupLoading && cachedGroups.isEmpty) {
          return Skeletonizer(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 4.0,
                  ),
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 22,
                        child: Icon(Icons.person),
                      ),
                      title: Container(
                        height: 16,
                        width: 150,
                        color: Colors.grey,
                      ),
                      subtitle: Container(
                        height: 14,
                        width: 200,
                        color: Colors.grey,
                      ),
                      trailing: Container(
                        height: 12,
                        width: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        // Get groups from state or cache
        final groups = state is GroupsLoaded ? state.groups : cachedGroups;

        if (groups.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return UniversalChatCard(group: group);
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

  @override
  void initState() {
    super.initState();

    getIt<GroupCubit>().loadCachedGroups();
    getIt<GroupCubit>().listenToGroups();
  }
}
