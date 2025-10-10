import 'package:flutter/material.dart';
import 'package:tabibi/core/style/spacing/horizental_space.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppHelperFunctions.isDarkMode(context)
            ? AppColors.darkBackground
            : AppColors.white,
        side: const BorderSide(color: AppColors.grey200, width: 1),
        shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.r8),
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: AppWidth.w20, height: AppHeight.h20),
          HorizentalSpace(width: AppWidth.w8),
         Text(text, style: Theme.of(context).textTheme.bodySmall)
        
        ],
      ),
    );
  }
}
