import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TextfieldMessage extends StatelessWidget {
  final void Function()? onPressedSend;
  final TextEditingController controller;
  final bool isSendEnabled;

  const TextfieldMessage({
    super.key,
    required this.onPressedSend,
    required this.controller,
    required this.isSendEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 6,
                  minLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.emoji_emotions_outlined),
                    ),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt_outlined),
                        ),
                      ],
                    ),
                    hintText: 'Message',
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            IconButton.filled(
              onPressed: isSendEnabled ? onPressedSend : null,
              icon: const Icon(Iconsax.send_1),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
