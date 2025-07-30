import 'package:chitchat/features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/app_snack_bar.dart';
import '../../cubits/group_selection_cubit/group_selection_cubit.dart';
import 'create_group_section.dart';
import 'members_list_view.dart';

class CreateGroupScreenBody extends StatelessWidget {
  final TextEditingController controller;
  const CreateGroupScreenBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is GroupError) {
          AppSnackBar.showError(context, state.message);
        }

        if (state is GroupSuccess) {
          AppSnackBar.showSuccess(context, state.message);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CreateGroupSection(groupNameController: controller),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Members',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  BlocBuilder<GroupSelectionCubit, Set<String>>(
                    builder: (context, selected) {
                      return Text(
                        '${selected.length}',
                        style: Theme.of(context).textTheme.labelLarge,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Expanded(child: MembersListView()),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
