import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/colors/colors.dart';
import 'custom_elevated_button.dart';
import 'custom_text_field.dart';

class SetupProfileBody extends StatefulWidget {
  final Map<String, String> userData;

  const SetupProfileBody({super.key, required this.userData});

  @override
  State<SetupProfileBody> createState() => _SetupProfileBodyState();
}

class _SetupProfileBodyState extends State<SetupProfileBody> {
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Welcome,', style: Theme.of(context).textTheme.displayMedium),
          Text(
            'to TalkVerse',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: AppColors.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Please Enter Your Name',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: 'Name',
                  prefixIcon: Iconsax.user,
                  controller: nameController,
                ),

                const SizedBox(height: 16),
                CustomElevatedButton(onPressed: () {}, label: 'Continue'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
