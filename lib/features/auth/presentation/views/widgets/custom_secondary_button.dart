import 'package:flutter/material.dart';

import '../../../../../core/constants/colors/colors.dart';

class CustomSecondaryButton extends StatelessWidget {
  final void Function()? onPressed;

  const CustomSecondaryButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        side: const BorderSide(color: AppColors.primaryColor),
      ),
      child: Center(
        child: Text(
          'CREATE ACCOUNT',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}
