import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

BoxDecoration softCardDecoration() {
  return BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(18.r),
    border: Border.all(color: AppColors.black.withValues(alpha: 0.1)),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.15),
        blurRadius: 3,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
