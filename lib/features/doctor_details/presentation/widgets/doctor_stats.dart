import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class DoctorStats extends StatelessWidget {
  final int patientCount;
  final int yearsOfExperience;
  final double rating;
  final int reviewCount;

  const DoctorStats({
    super.key,
    required this.patientCount,
    required this.yearsOfExperience,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(context, Iconsax.profile_2user, "$patientCount+", "Patients"),
        _buildStatItem(
          context,
          Iconsax.briefcase,
          "$yearsOfExperience+",
          "Years Exp.",
        ),
        _buildStatItem(context, Iconsax.star, "$rating+", "Rating"),
        _buildStatItem(context, Iconsax.message, "$reviewCount", "Review"),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(
              color: AppColors.grey500,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
