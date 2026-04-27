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
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
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
                  color: AppColors.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: AppColors.teal,
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
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(height: 1, color: AppColors.grey100),
          SizedBox(height: 14.h),
          _buildDetailRow(
            icon: Iconsax.weight,
            label: AppStrings.dosage,
            value: medicine.dosage,
          ),
          SizedBox(height: 10.h),
          _buildDetailRow(
            icon: Iconsax.repeat,
            label: AppStrings.frequency,
            value: medicine.frequency,
          ),
          SizedBox(height: 10.h),
          _buildDetailRow(
            icon: Iconsax.timer_1,
            label: AppStrings.duration,
            value: medicine.duration,
          ),
          if (medicine.instructions.isNotEmpty) ...[
            SizedBox(height: 10.h),
            _buildDetailRow(
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
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Icon(icon, size: 15.sp, color: AppColors.grey500),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.grey800,
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
