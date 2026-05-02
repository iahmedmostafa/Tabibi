import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/profile/data/mock_doctor_data.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/account_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/availability_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/danger_zone_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/profile_header.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/quick_action_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/security_section.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockDoctorData.getDoctorProfile();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppStrings.doctorAccount, style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
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
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
