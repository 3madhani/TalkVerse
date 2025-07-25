import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:chitchat/features/home/presentation/manager/contacts_cubit/contacts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widgets/app_snack_bar.dart';
import '../manager/contacts_cubit/contacts_state.dart';
import '../manager/contacts_view_model.dart';
import 'widgets/body_of_floating_action_button.dart';
import 'widgets/contact_card.dart';

class ContactsScreen extends StatelessWidget {
  static const routeName = 'contacts-screen';

  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactsViewModel(),
      child: Consumer<ContactsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title:
                  viewModel.searched
                      ? ContactsTextField(
                        searchController: viewModel.searchController,
                      )
                      : const Text('Contacts'),
              actions: [
                IconButton(
                  onPressed: viewModel.toggleSearch,
                  icon: Icon(
                    viewModel.searched
                        ? Iconsax.close_circle
                        : Iconsax.search_normal_1,
                  ),
                ),
              ],
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (ctx) {
                    return BlocProvider.value(
                      value: context.read<ContactsCubit>(),
                      child: BlocConsumer<ContactsCubit, ContactsState>(
                        listener: (context, state) {
                          if (state is ContactsSuccess) {
                            Navigator.pop(context);
                            if (state.message.contains("already exists")) {
                              AppSnackBar.showWarning(context, state.message);
                            } else {
                              AppSnackBar.showSuccess(context, state.message);
                            }
                          } else if (state is ContactsFailure) {
                            Navigator.pop(context);
                            AppSnackBar.showError(context, state.error);
                          }
                        },
                        builder: (context, state) {
                          return BodyOfBottomSheet(
                            label:
                                state is ContactsLoading
                                    ? 'Adding...'
                                    : 'Add Contact',
                            onAddUser: (ctx, email) {
                              context.read<ContactsCubit>().addContact(email);
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },

              child: const Icon(Iconsax.user_add),
            ),

            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<ContactsCubit, ContactsState>(
                      builder: (context, state) {
                        List<UserEntity> contacts = [];

                        if (state is ContactsLoaded) {
                          contacts = state.contacts;
                        } else if (state is ContactsAdding) {
                          contacts = state.currentContacts;
                        } else if (state is ContactsFailure &&
                            state.previousContacts.isNotEmpty) {
                          contacts = state.previousContacts;
                        }

                        if (contacts.isEmpty &&
                            (state is ContactsInitial ||
                                state is ContactsLoading)) {
                          return Skeletonizer(
                            child: ListView.builder(
                              itemCount: 20,
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
            ),
          );
        },
      ),
    );
  }
}

class ContactsTextField extends StatelessWidget {
  final TextEditingController searchController;
  const ContactsTextField({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        prefixIcon: const Icon(Iconsax.search_normal_1, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade800, // Light background
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
