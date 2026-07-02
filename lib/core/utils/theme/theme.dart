import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:tabibi/core/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:tabibi/core/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:tabibi/core/utils/theme/custom_themes/text_field_theme.dart';
import 'package:tabibi/core/utils/theme/custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.homeBackground,
    brightness: Brightness.light,
    textTheme: AppTextTheme.lightTextTheme,
    appBarTheme: AppBarThemes.lighAppBarTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: AppColors.white,
      brightness: Brightness.light,
    ),
    cardColor: AppColors.white,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemes.lighOutlinedButtonThemes,
    inputDecorationTheme: TextFormFieldThemes.lightInputDecorationTheme,
    dividerColor: AppColors.grey200,
    dividerTheme: DividerThemeData(
      color: AppColors.grey200,
      thickness: 1,
      space: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    textTheme: AppTextTheme.darkTextTheme,
    appBarTheme: AppBarThemes.darkAppBarTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: AppColors.grey900,
      brightness: Brightness.dark,
    ),
    cardColor: AppColors.grey900,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemes.darkOutlinedButtonTheme,
    inputDecorationTheme: TextFormFieldThemes.darkInputDecorationTheme,
    dividerColor: AppColors.grey800,
    dividerTheme: DividerThemeData(
      color: AppColors.grey800,
      thickness: 1,
      space: 1,
    ),
  );
}
