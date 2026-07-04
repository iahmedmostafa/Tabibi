import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';
import 'package:easy_localization/easy_localization.dart';

class AllergiesCard extends StatelessWidget {
  final Patient patient;

  const AllergiesCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.grey800 : AppColors.grey200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'allergiesCard'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.grey900,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: patient.allergies.map((allergy) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.red.shade900.withValues(alpha: 0.2)
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.red.shade800
                        : const Color(0xFFFFCDD2),
                  ),
                ),
                child: Text(
                  allergy,
                  style: TextStyle(
                    color: isDark
                        ? Colors.red.shade300
                        : const Color(0xFFD32F2F),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
