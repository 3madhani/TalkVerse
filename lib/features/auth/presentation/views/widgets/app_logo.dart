import 'package:chitchat/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/colors/colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.imagesAppLogo,
      height: 150,
      colorFilter: const ColorFilter.mode(
        AppColors.primaryColor,
        BlendMode.srcIn,
      ),
    );
  }
}
