import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.allDoctors),
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkBackground
              : AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: Theme.of(context).dividerColor == Colors.transparent
                ? AppColors.borderLight
                : Theme.of(context).dividerColor,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.midnightBlue.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(CupertinoIcons.search, color: AppColors.grey500, size: 22.sp),
            SizedBox(width: 14.w),
            Text(
              'Search doctor, specialty',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
