import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/widgets/app_snack_bar.dart';
import '../cubits/group_cubit/group_cubit.dart';
import '../cubits/group_selection_cubit/group_selection_cubit.dart';
import 'widgets/create_group_screen_body.dart';

class CreateGroupScreen extends StatelessWidget {
  static const routeName = '/create-group';

  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupNameController = TextEditingController();

    return BlocProvider(
      create: (context) => GroupSelectionCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Group')),
        floatingActionButton: Builder(
          builder:
              (fabContext) => FloatingActionButton.extended(
                onPressed: () => _createGroup(fabContext, groupNameController),
                label: Text(
                  'Done',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                icon: const Icon(Iconsax.tick_circle),
              ),
        ),
        body: CreateGroupScreenBody(controller: groupNameController),
      ),
    );
  }

  void _createGroup(BuildContext context, TextEditingController controller) {
    final groupName = controller.text.trim();
    final members = context.read<GroupSelectionCubit>().state.toList();

    if (groupName.isEmpty) {
      AppSnackBar.showWarning(context, 'Please enter a group name');
      return;
    }

    if (members.isEmpty) {
      AppSnackBar.showWarning(
        context,
        'Please select at least one member to add to the group',
      );
      return;
    }

    context.read<GroupCubit>().createGroup(
      groupName: groupName,
      members: members,
    );
  }
}
