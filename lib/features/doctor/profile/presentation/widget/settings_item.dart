import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isInteractive = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey800 : AppColors.grey100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: iconColor ?? (isDark ? AppColors.grey300 : AppColors.grey600),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.bodySMedium.copyWith(
                      color: isDark ? Colors.white : AppColors.grey900,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: AppTextStyle.bodyXsMedium.copyWith(
                        color: isDark ? AppColors.grey400 : AppColors.grey600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isInteractive)
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.grey600 : AppColors.grey400,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
