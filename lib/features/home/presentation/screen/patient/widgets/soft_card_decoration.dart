import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

BoxDecoration softCardDecoration(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: isDark ? AppColors.grey900 : AppColors.white,
    borderRadius: BorderRadius.circular(18.r),
    border: Border.all(
      color: isDark ? AppColors.grey800 : AppColors.black.withValues(alpha: 0.1),
    ),
    boxShadow: [
      BoxShadow(
        color: (isDark ? Colors.black : AppColors.primary).withValues(
          alpha: isDark ? 0.28 : 0.15,
        ),
        blurRadius: isDark ? 18 : 3,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
