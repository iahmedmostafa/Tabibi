import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.grey50),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.r66),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.dark,
       backgroundColor: AppColors.primary,
      // side: const BorderSide(color: AppColors.buttonPrimary),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.r15),
    ),
  );
}
