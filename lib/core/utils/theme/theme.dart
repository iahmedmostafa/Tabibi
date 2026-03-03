import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:tabibi/core/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:tabibi/core/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:tabibi/core/utils/theme/custom_themes/text_field_theme.dart';
import 'package:tabibi/core/utils/theme/custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  // ===== Doctor Feature Colors =====
  static const Color primaryColor = Color(0xFF1C2A3A);
  static const Color tealDark = Color(0xFF0D9891);

  // Pastel backgrounds
  static const Color bluePastel = Color(0xFFE3F2FD);
  static const Color greenPastel = Color(0xFFE8F5E9);
  static const Color redPastel = Color(0xFFFFEBEE);
  static const Color orangePastel = Color(0xFFFFF3E0);
  static const Color purplePastel = Color(0xFFF3E5F5);

  // Icon Colors
  static const Color blueIcon = Color(0xFF1E88E5);
  static const Color greenIcon = Color(0xFF43A047);
  static const Color redIcon = Color(0xFFE53935);
  static const Color orangeIcon = Color(0xFFFB8C00);
  static const Color purpleIcon = Color(0xFF8E24AA);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.lightBackground,
    brightness: Brightness.light,
    textTheme: AppTextTheme.lightTextTheme,
    appBarTheme: AppBarThemes.lighAppBarTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemes.lighOutlinedButtonThemes,
    inputDecorationTheme: TextFormFieldThemes.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    textTheme: AppTextTheme.darkTextTheme,
    appBarTheme: AppBarThemes.darkAppBarTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemes.darkOutlinedButtonTheme,
    inputDecorationTheme: TextFormFieldThemes.darkInputDecorationTheme,
  );
}
