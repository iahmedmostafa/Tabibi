import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class MapEmptyOverlay extends StatelessWidget {
  final VoidCallback onReset;

  const MapEmptyOverlay({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.grey900 : AppColors.white;
    final titleColor = isDark ? AppColors.white : AppColors.black;
    final bodyColor = isDark ? AppColors.grey400 : AppColors.grey600;

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.38 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.place_outlined, color: AppColors.primary, size: 42.sp),
            SizedBox(height: 10.h),
            Text(
              'noDoctorsFoundHere'.tr(),
              style: TextStyle(
                color: titleColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'trySearchingDifferentArea'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: bodyColor, fontSize: 12.sp, height: 1.4),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: onReset,
                child: Text('resetSearch'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
