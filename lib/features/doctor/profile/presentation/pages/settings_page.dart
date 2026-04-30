import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/profile/data/mock_doctor_data.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/account_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/availability_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/danger_zone_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/profile_header.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/quick_action_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/security_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockDoctorData.getDoctorProfile();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(profile: profile),
            SizedBox(height: 24.h),
            const AccountSection(),
            SizedBox(height: 24.h),
            const SecuritySection(),
            SizedBox(height: 24.h),
            AvailabilitySection(profile: profile),
            SizedBox(height: 24.h),
            const QuickActionsSection(),
            SizedBox(height: 24.h),
            const DangerZoneSection(),
            SizedBox(height: 80.h), // Space for bottom nav
          ],
        ),
      ),
    );
  }
}
