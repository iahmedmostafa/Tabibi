import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_border_radius.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';

class AppInputDecoration {
  AppInputDecoration._();

  static InputDecoration build(
    BuildContext context, {
    required bool isDark,
    String? hintText,
    IconData? prefixIcon,
  }) {
    final borderColor = isDark ? AppColors.grey700 : AppColors.grey300;
    final iconColor = isDark ? AppColors.grey400 : AppColors.grey500;

    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: isDark ? AppColors.grey500 : AppColors.grey400,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: iconColor, size: 20)
          : null,
      filled: true,
      fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
      border: OutlineInputBorder(
        borderRadius: AppBorderRadius.r12,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.r12,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.r12,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.r12,
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.r12,
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppWidth.w16,
        vertical: AppHeight.h16,
      ),
    );
  }

  static TextStyle? labelStyle(BuildContext context) => Theme.of(
    context,
  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600);
}
