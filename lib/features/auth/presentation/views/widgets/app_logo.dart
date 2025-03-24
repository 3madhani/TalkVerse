import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/constants/colors/colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/n_logo.svg',
      height: 150,
      colorFilter: const ColorFilter.mode(
        AppColors.primaryColor,
        BlendMode.srcIn,
      ),
    );
  }
}
