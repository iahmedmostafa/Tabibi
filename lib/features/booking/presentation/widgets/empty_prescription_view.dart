import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

class EmptyPrescriptionView extends StatelessWidget {
  const EmptyPrescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.grey900 : Colors.white;
    final borderColor = isDark ? AppColors.grey800 : AppColors.grey200;
    final titleColor = isDark ? AppColors.white : AppColors.grey900;
    final bodyColor = isDark ? AppColors.grey400 : AppColors.grey500;
    final iconBackground = isDark ? AppColors.grey800 : AppColors.grey100;
    final iconColor = isDark ? AppColors.grey400 : AppColors.grey400;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.26 : 0.045),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Iconsax.document,
                  size: 34.sp,
                  color: iconColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                AppStrings.noPrescriptionFound,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              Text(
                'Your prescription will appear here after your doctor publishes it.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: bodyColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
