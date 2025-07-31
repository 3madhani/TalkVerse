import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/get_it_services.dart';
import '../../cubits/group_selection_cubit/group_selection_cubit.dart';
import 'create_group_section.dart';
import 'members_list_view.dart';

class CreateGroupScreenBody extends StatelessWidget {
  final TextEditingController controller;
  const CreateGroupScreenBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
              Text('Add Members', style: Theme.of(context).textTheme.bodyLarge),
              BlocBuilder<GroupSelectionCubit, Set<String>>(
                bloc: getIt<GroupSelectionCubit>(),
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
        ],
      ),
    );
  }
}
