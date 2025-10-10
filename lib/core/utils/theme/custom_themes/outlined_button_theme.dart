import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';

class OutlinedButtonThemes {
  OutlinedButtonThemes._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lighOutlinedButtonThemes = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      // foregroundColor: AppColors.secondary,
      // side: const BorderSide(color: AppColors.secondary),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.r15),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.white),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.r15),
    ),
  );
}
