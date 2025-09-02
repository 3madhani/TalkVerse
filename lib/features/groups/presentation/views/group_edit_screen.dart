import 'package:chitchat/features/groups/presentation/views/groups_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/services/get_it_services.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/group_entity.dart';
import '../cubits/group_cubit/group_cubit.dart';
import '../cubits/group_selection_cubit/group_selection_cubit.dart';
import 'widgets/group_edit_screen_body.dart';

class GroupEditScreen extends StatefulWidget {
  static const routeName = '/group-edit-screen';
  final GroupEntity group;

  const GroupEditScreen({super.key, required this.group});

  @override
  State<GroupEditScreen> createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends State<GroupEditScreen> {
  final editGroupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Group')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editGroup(context, editGroupNameController),
        label: Text('Done', style: Theme.of(context).textTheme.labelLarge),
        icon: const Icon(Iconsax.tick_circle),
      ),
      body: GroupEditScreenBody(controller: editGroupNameController),
    );
  }

  @override
  void dispose() {
    editGroupNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    editGroupNameController.text = widget.group.name;
    // call by value to avoid modifying the original list
    final groupMembers = List<String>.from(widget.group.members);
    groupMembers.remove(FirebaseAuth.instance.currentUser?.uid);
    getIt<GroupSelectionCubit>().setMembers(groupMembers);
    super.initState();
  }

  void _editGroup(BuildContext context, TextEditingController controller) {
    final groupName = controller.text.trim();
    final newMembers = getIt<GroupSelectionCubit>().state.toList();

    final oldMembers = List<String>.from(widget.group.members)
      ..remove(FirebaseAuth.instance.currentUser?.uid);

    if (groupName.isEmpty) {
      AppSnackBar.showWarning(context, 'Please enter a group name');
      return;
    }

    final sameName = groupName == widget.group.name;
    final sameMembers = setEquals(newMembers.toSet(), oldMembers.toSet());

    if (sameName && sameMembers) {
      AppSnackBar.showWarning(context, 'No changes made to the group');
      return;
    }

    if (newMembers.isEmpty) {
      AppSnackBar.showWarning(
        context,
        'Please select at least one member to add to the group',
      );
      return;
    }

    getIt<GroupCubit>().updateGroup(
      groupId: widget.group.id,
      groupName: groupName,
      members: [...newMembers, FirebaseAuth.instance.currentUser!.uid],
    );
    getIt<GroupSelectionCubit>().clearSelection();
    Navigator.pushNamedAndRemoveUntil(
      context,
      GroupsScreen.routeName,
      (route) => route.settings.name == GroupsScreen.routeName,
    );

    if (!kIsWeb) {
      getIt<GroupCubit>().listenToGroups();
    }

    AppSnackBar.showSuccess(context, 'Group updated successfully');
  }
}
