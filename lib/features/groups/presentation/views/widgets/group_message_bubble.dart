import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupMessageBubble extends StatelessWidget {
  final int index;
  const GroupMessageBubble({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          index % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        index % 2 == 0
            ? IconButton(
              onPressed: () {},
              icon: const Icon(Iconsax.message_edit),
            )
            : const SizedBox(),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(index % 2 == 0 ? 14 : 0),
              bottomRight: Radius.circular(index % 2 == 0 ? 0 : 14),
            ),
          ),
          color:
              index % 2 == 0
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.7,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index % 2 == 0
                    ? const SizedBox()
                    : const Text(
                      textAlign: TextAlign.start,
                      "Name", // Static message
                      style: TextStyle(fontSize: 16),
                    ),
                const Text(
                  "Hello! This is a test message.", // Static message
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "10:30 AM", // Static time
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: Colors.grey),
                    ),

                    const SizedBox(width: 5),
                    index % 2 == 0
                        ? const Icon(
                          Iconsax.tick_circle5, // Read status icon
                          size: 16,
                          color: Colors.blue,
                        )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
