import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/views/widgets/custom_elevated_button.dart';
import '../../../auth/presentation/views/widgets/custom_text_field.dart';
import '../manager/contacts_view_model.dart';
import 'widgets/contact_card.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  static const routeName = 'contacts-screen';

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
                      ? TextField(
                        autofocus: true,
                        controller: viewModel.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Iconsax.search_normal_1,
                            color: Colors.grey,
                          ),
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
              onPressed: () => _showAddContactBottomSheet(context),
              child: const Icon(Iconsax.user_add),
            ),

            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return const ContactCard();
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

  void _showAddContactBottomSheet(BuildContext context) {
    final viewModel = Provider.of<ContactsViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Friend Email',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Iconsax.scan_barcode),
                  ),
                ],
              ),
              CustomTextField(
                label: 'Email',
                prefixIcon: Iconsax.direct,
                controller: viewModel.emailController,
              ),
              const SizedBox(height: 16),
              CustomElevatedButton(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                label: 'Add Contact',
                onPressed: () {},
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
