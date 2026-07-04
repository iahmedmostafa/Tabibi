import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class MapLoadingOverlay extends StatelessWidget {
  const MapLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.grey900 : AppColors.white;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final bodyColor = isDark ? AppColors.grey400 : AppColors.grey600;

    return IgnorePointer(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: surface.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(strokeWidth: 2.4),
              ),
              SizedBox(width: 12.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'findingDoctorsNearby'.tr(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'updatingMapResults'.tr(),
                    style: TextStyle(color: bodyColor, fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
