import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/get_it_services.dart';
import '../../../../home/presentation/manager/contacts_cubit/contacts_cubit.dart';
import '../../../../home/presentation/manager/contacts_cubit/contacts_state.dart';
import '../../cubits/group_selection_cubit/group_selection_cubit.dart';

class MembersListView extends StatefulWidget {
  const MembersListView({super.key});

  @override
  State<MembersListView> createState() => _MembersListViewState();
}

class _MembersListViewState extends State<MembersListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      bloc: getIt<ContactsCubit>(),
      builder: (context, state) {
        if (state is ContactsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ContactsFailure) {
          return Center(child: Text(state.error));
        }
        if (state is ContactsLoaded) {
          return BlocBuilder<GroupSelectionCubit, Set<String>>(
            bloc: getIt<GroupSelectionCubit>(),
            builder: (context, selectedIds) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.contacts.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final member = state.contacts[index];
                  final isSelected = selectedIds.contains(member.uId);

                  return CheckboxListTile(
                    value: isSelected,
                    onChanged:
                        (_) => getIt<GroupSelectionCubit>().toggleMember(
                          member.uId,
                        ),
                    checkboxShape: const CircleBorder(),
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Text(
                      member.name ?? '',
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    secondary: CircleAvatar(
                      child: Text(
                        member.name![0].toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  @override
  void initState() {
    getIt<ContactsCubit>().loadContacts();
    super.initState();
  }
}
