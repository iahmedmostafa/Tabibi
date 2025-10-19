import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';

class AppTextTheme {
  AppTextTheme._();

  /* -- Light Text Theme -- */
  static TextTheme lightTextTheme = TextTheme(
    // Headings
    headlineLarge: AppTextStyle.h1.copyWith(color: AppColors.textPrimary),
    headlineMedium: AppTextStyle.h2.copyWith(color: AppColors.textPrimary),
    headlineSmall: AppTextStyle.h3.copyWith(color: AppColors.textPrimary),
    titleLarge: AppTextStyle.h4.copyWith(color: AppColors.textPrimary),

    // Body
    bodyLarge: AppTextStyle.bodyXl.copyWith(color: AppColors.textPrimary),
    bodyMedium: AppTextStyle.bodySRegular.copyWith(color: AppColors.grey400),
    bodySmall: AppTextStyle.bodySMedium.copyWith(
      color: AppColors.primary,
    ),

    // Labels
    labelLarge: AppTextStyle.button.copyWith(color: AppColors.textWhite),
    labelSmall: AppTextStyle.bodyXsRegular.copyWith(color: AppColors.grey500),
  );

  /* -- Dark Text Theme -- */
  static TextTheme darkTextTheme = TextTheme(
    // Headings
    headlineLarge: AppTextStyle.h1.copyWith(color: AppColors.textDarkPrimary),
    headlineMedium: AppTextStyle.h2.copyWith(color: AppColors.textDarkPrimary),
    headlineSmall: AppTextStyle.h3.copyWith(color: AppColors.textDarkPrimary),
    titleLarge: AppTextStyle.h4.copyWith(color: AppColors.textDarkPrimary),

    // Body
    bodyLarge: AppTextStyle.bodyXl.copyWith(color: AppColors.textDarkPrimary),
    bodyMedium: AppTextStyle.bodyLg.copyWith(color: AppColors.textDarkPrimary),
    bodySmall: AppTextStyle.bodySRegular.copyWith(
      color: AppColors.textDarkSecondary,
    ),

    // Labels
    labelLarge: AppTextStyle.button.copyWith(color: AppColors.textDarkPrimary),
    labelSmall: AppTextStyle.bodyXsRegular.copyWith(color: AppColors.grey200),
  );
}
