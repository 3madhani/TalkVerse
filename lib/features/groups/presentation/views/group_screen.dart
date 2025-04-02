import 'package:chitchat/features/groups/presentation/views/widgets/group_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/widgets/text_field_message.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Group Name'),
            Text(
              'Emad, Ahmed, Ali ...',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Iconsax.user))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                reverse: true,
                itemCount: 10,
                itemBuilder:
                    (context, index) => GroupMessageBubble(index: index),
              ),
            ),

            //   child: Center(
            //     child: InkResponse(
            //       onTap: () {},
            //       child: Card(
            //         color: Theme.of(context).colorScheme.primaryContainer,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.all(16.0),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text(
            //                 '👋',
            //                 style: Theme.of(context).textTheme.displayLarge,
            //               ),
            //               const SizedBox(height: 16),
            //               Text(
            //                 'Hello My Friend',
            //                 style: Theme.of(
            //                   context,
            //                 ).textTheme.labelLarge?.copyWith(
            //                   color:
            //                       Theme.of(
            //                         context,
            //                       ).colorScheme.onPrimaryContainer,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const TextfieldMessage(),
          ],
        ),
      ),
    );
  }
}
