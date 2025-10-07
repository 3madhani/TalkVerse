import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/services/get_it_services.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../manager/contacts_cubit/contacts_cubit.dart';
import '../manager/contacts_cubit/contacts_state.dart';
import 'contact_card.dart';

class ContactsScreenBody extends StatefulWidget {
  const ContactsScreenBody({super.key});

  @override
  State<ContactsScreenBody> createState() => _ContactsScreenBodyState();
}

class _ContactsScreenBodyState extends State<ContactsScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ContactsCubit, ContactsState>(
              bloc: getIt<ContactsCubit>(),
              builder: (context, state) {
                List<UserEntity> contacts = [];

                if (state is ContactsSearchResult) {
                  contacts = state.searchResults;
                } else if (state is ContactsLoaded) {
                  contacts = state.contacts;
                } else if (state is ContactsAdding) {
                  contacts = state.currentContacts;
                } else if (state is ContactsFailure &&
                    state.previousContacts.isNotEmpty) {
                  contacts = state.previousContacts;
                }

                if (contacts.isEmpty &&
                    (state is ContactsInitial || state is ContactsLoading)) {
                  return Skeletonizer(
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return const ContactCard(
                          contact: UserEntity(uId: '', email: ''),
                        );
                      },
                    ),
                  );
                }

                if (contacts.isEmpty) {
                  return Center(
                    child: Text(
                      'You have no contacts yet...',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return ContactCard(contact: contacts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getIt<ContactsCubit>().loadContacts();
  }
}
