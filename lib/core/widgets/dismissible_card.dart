import 'package:flutter/material.dart';

class DismissibleCard extends StatelessWidget {
  final String id;
  final Widget child;
  final Future<void> Function()? onDismiss;
  final bool confirm;
  final String title;
  final String content;

  const DismissibleCard({
    super.key,
    required this.id,
    required this.child,
    this.onDismiss,
    this.confirm = true,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        if (!confirm) return true;
        return await showDialog<bool>(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: Text(title),
                    content: Text(
                      'Are you sure you want to delete this $content?',
                      style: const TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
            ) ??
            false;
      },
      onDismissed: (_) async {
        if (onDismiss != null) await onDismiss!();
      },
      child: child,
    );
  }
}
