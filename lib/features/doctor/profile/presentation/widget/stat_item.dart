import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.h1.copyWith(
            color: isDark ? Colors.white : AppColors.grey900,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.bodyXsMedium.copyWith(
            color: isDark ? AppColors.grey400 : AppColors.grey600,
          ),
        ),
      ],
    );
  }
}