import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';

class TextFormFieldThemes {
  TextFormFieldThemes._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    // prefixIconColor: AppColors.secondary,
    // floatingLabelStyle: const TextStyle(color: AppColors.secondary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      // borderSide: const BorderSide(width: 2, color: AppColors.secondary),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: AppColors.primary,
    floatingLabelStyle: const TextStyle(color: AppColors.primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      borderSide: const BorderSide(width: 2, color: AppColors.primary),
    ),
  );
}
