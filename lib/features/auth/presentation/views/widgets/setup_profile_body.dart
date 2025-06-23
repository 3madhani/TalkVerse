import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../home/presentation/views/home_layout.dart';
import 'custom_elevated_button.dart';
import 'custom_text_field.dart';

class SetupProfileBody extends StatelessWidget {
  const SetupProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Welcome,', style: Theme.of(context).textTheme.displayMedium),
          Text('to ChitChat', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Text(
            'Please Enter Your Name',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          CustomTextField(
            label: 'Name',
            prefixIcon: Iconsax.user,
            controller: nameController,
          ),

          const SizedBox(height: 16),
          CustomElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomeLayout.routeName,
                (route) => false,
              );
            },
            label: 'Continue',
          ),
        ],
      ),
    );
  }
}
