import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/services/get_it_services.dart';
import '../../../../auth/presentation/views/widgets/custom_text_field.dart';
import '../../cubits/group_selection_cubit/group_selection_cubit.dart';
import 'edit_members_list_view.dart';

class GroupEditScreenBody extends StatelessWidget {
  final TextEditingController controller;
  const GroupEditScreenBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CircleAvatar(radius: 40),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton.filled(
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          padding: const EdgeInsets.all(8),
                          shape: CircleBorder(
                            side: BorderSide(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                        icon: const Icon(Iconsax.camera, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'Group Name',
                  prefixIcon: Iconsax.user_octagon,
                  controller: controller,
                ),
              ),
            ],
          ),
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
          const Expanded(child: EditMembersListView()),
        ],
      ),
    );
  }
}
