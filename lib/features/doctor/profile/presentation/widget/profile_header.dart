import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/stat_item.dart';

class ProfileHeader extends StatelessWidget {
  final DoctorProfile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF5F8D8F),
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
                    color: const Color(0xFF2C3E50),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
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
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            profile.specialty,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 4.h),
          Text(
            'ID: ${profile.doctorId}',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatItem(value: profile.rating.toString(), label: 'Rating'),
              Container(width: 1, height: 40.h, color: Colors.grey[300]),
              StatItem(value: profile.reviews.toString(), label: 'Reviews'),
              Container(width: 1, height: 40.h, color: Colors.grey[300]),
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
