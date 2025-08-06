import 'package:flutter/material.dart';

class StartMessageCard extends StatelessWidget {
  final void Function()? onTap;
  final String roomName;

  const StartMessageCard({super.key, this.onTap, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkResponse(
        onTap: onTap,
        child: Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '👋',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge!.copyWith(fontSize: 100),
                ),
                const SizedBox(height: 16),
                Text(
                  "Hi, $roomName!\n"
                  "Let's start chatting here.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
