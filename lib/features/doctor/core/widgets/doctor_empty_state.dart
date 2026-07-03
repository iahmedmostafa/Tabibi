import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class DoctorEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final double? iconSize;

  const DoctorEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize ?? 48.sp,
              color: isDark ? AppColors.grey700 : AppColors.grey300,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.grey400 : AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
