import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/sizes.dart';

class AppBarThemes {
  AppBarThemes._();

  static const lighAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: AppColors.dark, size: AppSizes.fontSizeLg),
    actionsIconTheme: IconThemeData(color: AppColors.dark, size: AppSizes.fontSizeLg),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: AppColors.white, size: AppSizes.fontSizeLg),
    actionsIconTheme: IconThemeData(color: AppColors.white, size: AppSizes.fontSizeLg),
  );
}
