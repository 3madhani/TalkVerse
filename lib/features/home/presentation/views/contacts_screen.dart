import 'package:chitchat/features/home/presentation/manager/contacts_cubit/contacts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_snack_bar.dart';
import '../manager/contacts_cubit/contacts_state.dart';
import '../manager/contacts_view_model.dart';
import 'widgets/body_of_floating_action_button.dart';
import 'widgets/contacts_screen_body.dart';
import 'widgets/contacts_text_field.dart';

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
                        onChanged: (value) {
                          context.read<ContactsCubit>().searchContacts(value);
                        },
                      )
                      : const Text('Contacts'),
              actions: [
                IconButton(
                  onPressed: () {
                    viewModel.toggleSearch();
                    context.read<ContactsCubit>().clearSearch();
                  },
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

                            AppSnackBar.showSuccess(context, state.message);
                          } else if (state is ContactsFailure) {
                            Navigator.pop(context);
                            if (state.error.contains('already exists')) {
                              AppSnackBar.showWarning(context, state.error);
                            } else {
                              AppSnackBar.showError(context, state.error);
                            }
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

            body: const ContactsScreenBody(),
          );
        },
      ),
    );
  }
}
