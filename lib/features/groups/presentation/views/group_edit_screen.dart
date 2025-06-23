import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../auth/presentation/views/widgets/custom_text_field.dart';

class GroupEditScreen extends StatelessWidget {
  static const routeName = '/group-edit-screen';

  const GroupEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Group')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Done', style: Theme.of(context).textTheme.labelLarge),
        icon: const Icon(Iconsax.tick_circle),
      ),
      body: Padding(
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
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_a_photo),
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
                    controller: TextEditingController(),
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
                Text(
                  'Add Members',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text('0', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  CheckboxListTile(
                    checkboxShape: const CircleBorder(),
                    value: false,
                    onChanged: (_) {},
                    title: const Text('Emad'),
                  ),
                  CheckboxListTile(
                    value: true,
                    checkboxShape: const CircleBorder(),
                    onChanged: (_) {},
                    title: const Text('Emad'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
