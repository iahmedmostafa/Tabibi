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
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Name Header
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.midnightBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color:
                          Theme.of(context).textTheme.bodyMedium?.color ??
                          AppColors.midnightBlue,
                      fontWeight: FontWeight.bold,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: Theme.of(context).dividerColor),
          SizedBox(height: 12.h),

          // Medicine Details Grid
          _buildDetailRow(
            context: context,
            icon: Iconsax.weight,
            label: AppStrings.dosage,
            value: medicine.dosage,
          ),
          SizedBox(height: 10.h),
          _buildDetailRow(
            context: context,
            icon: Iconsax.repeat,
            label: AppStrings.frequency,
            value: medicine.frequency,
          ),
          SizedBox(height: 10.h),
          _buildDetailRow(
            context: context,
            icon: Iconsax.timer_1,
            label: AppStrings.duration,
            value: medicine.duration,
          ),
          if (medicine.instructions.isNotEmpty) ...[
            SizedBox(height: 10.h),
            _buildDetailRow(
              context: context,
              icon: Iconsax.info_circle,
              label: AppStrings.instructions,
              value: medicine.instructions,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: AppColors.grey400),
        SizedBox(width: 8.w),
        SizedBox(
          width: 85.w,
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.grey500,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color:
                  Theme.of(context).textTheme.bodyLarge?.color ??
                  AppColors.grey700,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
