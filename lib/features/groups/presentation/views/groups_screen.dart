import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/services/get_it_services.dart';
import '../../domain/repos/group_repo.dart';
import '../cubits/group_cubit/group_cubit.dart';
import 'create_group_screen.dart';
import 'widgets/groups_screen_body.dart';

class GroupsScreen extends StatelessWidget {
  static const routeName = 'groups-screen';

  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupCubit(getIt<GroupRepo>())..loadGroups(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Groups')),
        floatingActionButton: FloatingActionButton(
          heroTag: 'groups-screen-fab',
          onPressed: () {
            Navigator.pushNamed(context, CreateGroupScreen.routeName);
          },
          child: const Icon(Iconsax.message_add_1),
        ),
        body: const GroupsScreenBody(),
      ),
    );
  }
}
