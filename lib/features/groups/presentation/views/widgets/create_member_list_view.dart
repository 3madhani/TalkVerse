import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/get_it_services.dart';
import '../../../../home/presentation/manager/contacts_cubit/contacts_cubit.dart';
import '../../../../home/presentation/manager/contacts_cubit/contacts_state.dart';
import '../../cubits/group_selection_cubit/group_selection_cubit.dart';

class CreateMemberListView extends StatefulWidget {
  const CreateMemberListView({super.key});

  @override
  State<CreateMemberListView> createState() => _CreateMemberListViewState();
}

class _CreateMemberListViewState extends State<CreateMemberListView> {
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

                  return Card(
                    margin: EdgeInsets.zero,
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (_) {
                        getIt<GroupSelectionCubit>().toggleMember(member.uId);
                      },
                      checkboxShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text(
                        member.name ?? '',
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      secondary: CircleAvatar(
                        radius: 22,
                        backgroundColor:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                        child:
                            member.photoUrl == null
                                ? Text(
                                  member.name != null && member.name!.isNotEmpty
                                      ? member.name![0].toUpperCase()
                                      : '?',
                                )
                                : ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: member.photoUrl!,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (_, __) => const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    errorWidget:
                                        (_, __, ___) => const Icon(Icons.error),
                                  ),
                                ),
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
    super.initState();
    getIt<ContactsCubit>().loadContacts();
    getIt<GroupSelectionCubit>().clearSelection();
  }
}
