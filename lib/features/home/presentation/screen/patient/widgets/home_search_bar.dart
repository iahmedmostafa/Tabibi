import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.grey900 : AppColors.white;
    final borderColor = isDark ? AppColors.grey700 : AppColors.grey200;

    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.allDoctors),
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.midnightBlue.withValues(alpha: 0.05),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Iconsax.search_normal,
              color: AppColors.primary,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Search doctor, specialty',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.grey400 : AppColors.grey500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: AppColors.primary,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
