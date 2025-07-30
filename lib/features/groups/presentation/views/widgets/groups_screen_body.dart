import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/app_snack_bar.dart';
import '../../cubits/group_cubit/group_cubit.dart';
import 'group_card.dart';

class GroupsScreenBody extends StatelessWidget {
  const GroupsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<GroupCubit, GroupState>(
              listener: (context, state) {
                if (state is GroupError) {
                  AppSnackBar.showError(context, state.message);
                }
                if (state is GroupCreated) {
                  AppSnackBar.showSuccess(context, state.message);
                  
                }
                if (state is GroupUpdated) {
                  AppSnackBar.showSuccess(context, state.message);
                }
                if (state is GroupDeleted) {
                  AppSnackBar.showSuccess(
                    context,
                    'Group with ID ${state.name} deleted successfully',
                  );
                }
              },
              builder: (context, state) {
                if (state is GroupError) {
                  return Center(child: Text(state.message));
                }
                if (state is GroupLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GroupLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: state.groups.length,
                    itemBuilder:
                        (context, index) =>
                            GroupCard(group: state.groups[index]),
                  );
                }
                return Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'You have no groups yet'
                    '\nCreate one to start a conversation',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
