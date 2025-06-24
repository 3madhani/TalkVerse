import 'package:flutter/material.dart';

import '../../../../../core/constants/colors/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final Color backgroundColor;
  const CustomElevatedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shadowColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        backgroundColor: backgroundColor,
      ),
      child: Center(
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
