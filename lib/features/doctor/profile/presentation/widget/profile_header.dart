import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/stat_item.dart';

class ProfileHeader extends StatelessWidget {
  final DoctorProfile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(24.w),
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                  color: AppTheme.tealDark,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    profile.initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            profile.name,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
          SizedBox(height: 4.h),
          Text(
            profile.specialty,
            style: TextStyle(fontSize: 14.sp, color: theme.colorScheme.onSurfaceVariant),
          ),
          SizedBox(height: 4.h),
          Text(
            'ID: ${profile.doctorId}',
            style: TextStyle(fontSize: 12.sp, color: theme.colorScheme.onSurfaceVariant),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatItem(value: profile.rating.toString(), label: 'Rating'),
              Container(width: 1, height: 40.h, color: theme.dividerColor),
              StatItem(value: profile.reviews.toString(), label: 'Reviews'),
              Container(width: 1, height: 40.h, color: theme.dividerColor),
              StatItem(
                value: profile.yearsOfExperience.toString(),
                label: 'Years',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
