import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:easy_localization/easy_localization.dart';

class MedicinesHeader extends StatelessWidget {
  final int count;
  final VoidCallback onAddMedicine;

  const MedicinesHeader({
    super.key,
    required this.count,
    required this.onAddMedicine,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DoctorCard(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(Iconsax.hospital, color: AppColors.teal, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'medicinesHeader'.tr(),
                  style: AppTextStyle.h3.copyWith(
                    color: isDark ? Colors.white : AppColors.grey900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'itemsAdded'.tr(namedArgs: {'count': count.toString()}),
                  style: AppTextStyle.bodyXsMedium.copyWith(
                    color: isDark ? AppColors.grey400 : AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton.icon(
            onPressed: onAddMedicine,
            icon: Icon(Icons.add, size: 18.sp),
            label: Text('add'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
