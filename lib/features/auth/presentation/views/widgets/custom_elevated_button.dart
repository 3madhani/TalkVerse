import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/colors/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  const CustomElevatedButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        backgroundColor: AppColors.primaryColor,
      ),
      child: Center(
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
