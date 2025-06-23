import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/colors/colors.dart';

class SocialButton extends StatelessWidget {
  final void Function()? onTap;
  final String icon;
  const SocialButton({super.key, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: SvgPicture.asset(icon, height: 35, width: 35),
      ),
    );
  }
}
