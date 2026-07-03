import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';

class PatientHeaderCard extends StatelessWidget {
  final Patient patient;

  const PatientHeaderCard({super.key, required this.patient});

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
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF8FB89C),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    _getInitials(patient.name),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.grey900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Patient ID: ${patient.patientId}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? AppColors.grey400 : AppColors.grey600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.green.shade900.withValues(alpha: 0.2) : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isDark ? Colors.green.shade800 : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        'Active Patient',
                        style: TextStyle(
                          color: isDark ? Colors.green.shade300 : const Color(0xFF4CAF50),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Age',
                  '${patient.age} years',
                  isDark ? AppColors.grey300 : AppColors.grey800,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Gender',
                  patient.gender,
                  isDark ? AppColors.grey300 : AppColors.grey800,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Blood Group',
                  patient.bloodGroup,
                  const Color(0xFFD32F2F),
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Weight',
                  patient.weight,
                  isDark ? AppColors.grey300 : AppColors.grey800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, Color valueColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? AppColors.grey400 : Colors.grey[500],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}
