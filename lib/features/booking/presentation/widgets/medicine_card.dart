import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/booking/data/models/prescription_model.dart';

class MedicineCard extends StatelessWidget {
  final MedicineModel medicine;
  final int index;

  const MedicineCard({super.key, required this.medicine, required this.index});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.grey900 : Colors.white;
    final borderColor = isDark ? AppColors.grey800 : AppColors.grey200;
    final titleColor = isDark ? AppColors.white : AppColors.grey900;
    final labelColor = isDark ? AppColors.grey400 : AppColors.grey500;
    final valueColor = isDark ? AppColors.grey200 : AppColors.grey800;
    final dividerColor = isDark ? AppColors.grey800 : AppColors.grey100;
    final iconBackground = isDark ? AppColors.grey800 : AppColors.grey100;
    final iconColor = isDark ? AppColors.grey300 : AppColors.grey500;
    final badgeBackground = isDark ? AppColors.grey800 : AppColors.teal.withValues(alpha: 0.12);
    final badgeTextColor = isDark ? AppColors.teal20 : AppColors.teal;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: badgeBackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: badgeTextColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  medicine.medicineName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(height: 1, color: dividerColor),
          SizedBox(height: 14.h),
          _buildDetailRow(
            icon: Iconsax.weight,
            label: AppStrings.dosage,
            value: medicine.dosage,
            labelColor: labelColor,
            valueColor: valueColor,
            iconBackground: iconBackground,
            iconColor: iconColor,
          ),
          SizedBox(height: 10.h),
          _buildDetailRow(
            icon: Iconsax.repeat,
            label: AppStrings.frequency,
            value: medicine.frequency,
            labelColor: labelColor,
            valueColor: valueColor,
            iconBackground: iconBackground,
            iconColor: iconColor,
          ),
          SizedBox(height: 10.h),
          _buildDetailRow(
            icon: Iconsax.timer_1,
            label: AppStrings.duration,
            value: medicine.duration,
            labelColor: labelColor,
            valueColor: valueColor,
            iconBackground: iconBackground,
            iconColor: iconColor,
          ),
          if (medicine.instructions.isNotEmpty) ...[
            SizedBox(height: 10.h),
            _buildDetailRow(
              icon: Iconsax.info_circle,
              label: AppStrings.instructions,
              value: medicine.instructions,
              labelColor: labelColor,
              valueColor: valueColor,
              iconBackground: iconBackground,
              iconColor: iconColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color labelColor,
    required Color valueColor,
    required Color iconBackground,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Icon(icon, size: 15.sp, color: iconColor),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
