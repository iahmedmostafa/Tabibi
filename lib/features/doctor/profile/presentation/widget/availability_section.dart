import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class AvailabilitySection extends StatelessWidget {
  final DoctorProfile profile;

  const AvailabilitySection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Availability',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          color: Colors.white,
          child: SettingsItem(
            icon: Icons.access_time,
            title: 'Working Hours',
            subtitle: profile.workingHours,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
