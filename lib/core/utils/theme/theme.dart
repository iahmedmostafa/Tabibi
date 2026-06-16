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

  // Pastel backgrounds (for light theme)
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
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.grey50,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.midnightBlue,
      secondary: AppColors.teal,
      surface: Colors.white,
      onSurface: AppColors.midnightBlue,
      onSurfaceVariant: AppColors.grey600,
      surfaceContainerHighest: AppColors.grey100,
      outline: AppColors.grey200,
      error: AppColors.error,
    ),
    textTheme: AppTextTheme.lightTextTheme,
    appBarTheme: AppBarThemes.lighAppBarTheme.copyWith(
      backgroundColor: AppColors.grey50,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    cardColor: Colors.white,
    dividerColor: AppColors.grey200,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemes.lighOutlinedButtonThemes,
    inputDecorationTheme: TextFormFieldThemes.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2DD4BF), // Bright teal for dark mode
      secondary: Color(0xFF60A5FA), // Bright blue
      surface: Color(0xFF1E293B), // Slate 800
      onSurface: Colors.white,
      onSurfaceVariant: Color(0xFF94A3B8), // Slate 400
      surfaceContainerHighest: Color(0xFF334155), // Slate 700
      outline: Color(0xFF475569), // Slate 600
      error: Color(0xFFF87171), // Red 400
    ),
    textTheme: AppTextTheme.darkTextTheme,
    appBarTheme: AppBarThemes.darkAppBarTheme.copyWith(
      backgroundColor: const Color(0xFF0F172A),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    cardColor: const Color(0xFF1E293B),
    dividerColor: const Color(0xFF334155),
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemes.darkOutlinedButtonTheme,
    inputDecorationTheme: TextFormFieldThemes.darkInputDecorationTheme,
  );
}
