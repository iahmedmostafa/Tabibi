import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/doctor_profile_cubit.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/doctor_profile_state.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/account_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/availability_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/danger_zone_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/profile_header.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/quick_action_section.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/security_section.dart';

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DoctorProfileCubit>()..fetchDoctorProfile(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(AppStrings.doctorAccount, style: TextStyle(fontSize: 20.sp)),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
          builder: (context, state) {
            if (state is DoctorProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoctorProfileError) {
              return _buildErrorState(context, state.message);
            } else if (state is DoctorProfileLoaded) {
              final profile = state.profile;
              return RefreshIndicator(
                onRefresh: () => context.read<DoctorProfileCubit>().fetchDoctorProfile(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeader(profile: profile),
                      SizedBox(height: 24.h),
                      AccountSection(profile: profile),
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: theme.colorScheme.error),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: () => context.read<DoctorProfileCubit>().fetchDoctorProfile(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
