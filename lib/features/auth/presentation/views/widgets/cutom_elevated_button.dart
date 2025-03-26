import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/colors/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        backgroundColor: AppColors.primaryColor,
      ),
      child: const Center(
        child: Text('LOGIN', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
