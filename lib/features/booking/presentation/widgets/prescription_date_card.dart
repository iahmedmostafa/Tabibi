import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:easy_localization/easy_localization.dart';

class PrescriptionDateCard extends StatelessWidget {
  final String createdAt;

  const PrescriptionDateCard({super.key, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [AppColors.grey900, AppColors.darkBackground]
        : [AppColors.midnightBlue, AppColors.blue600];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightBlue.withValues(
              alpha: isDark ? 0.28 : 0.20,
            ),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.13),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.12),
                  ),
                ),
                child: Icon(
                  Iconsax.document_text,
                  color: Colors.white,
                  size: 25.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  'yourMedicalPrescription'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.11),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.calendar_1, color: Colors.white70, size: 15.sp),
                SizedBox(width: 7.w),
                Text(
                  AppStrings.prescriptionDate,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 1,
                  height: 14.h,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    Formatter.formatIsoToDateTime(createdAt),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'reviewDiagnosisInstructions'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }
}
