import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        _buildStatItem(context, Icons.people, "$patientCount+", "patients"),
        _buildStatItem(
          context,
          Icons.work,
          "$yearsOfExperience+",
          "experience",
        ),
        _buildStatItem(context, Icons.star, "$rating", "rating"),
        _buildStatItem(context, Icons.chat, "$reviewCount", "reviews"),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.grey100,
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
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.grey500),
        ),
      ],
    );
  }
}
