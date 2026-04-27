import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/profile/data/mock_doctor_data.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/doctor_logout_cubit.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/doctor_logout_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockDoctorData.getDoctorProfile();

    return BlocProvider(
      create: (context) => sl<DoctorLogoutCubit>(),
      child: BlocConsumer<DoctorLogoutCubit, DoctorLogoutState>(
        listener: (context, state) {
          if (state is DoctorLogoutSuccess) {
            context.goNamed(AppRoutes.login);
          }
          if (state is DoctorLogoutError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
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
                      _ProfileHeader(profile: profile),
                      SizedBox(height: 24.h),
                      const _AccountSection(),
                      SizedBox(height: 24.h),
                      const _SecuritySection(),
                      SizedBox(height: 24.h),
                      _AvailabilitySection(profile: profile),
                      SizedBox(height: 24.h),
                      const _QuickActionsSection(),
                      SizedBox(height: 24.h),
                      const _DangerZoneSection(),
                      SizedBox(height: 80.h), // Space for bottom nav
                    ],
                  ),
                ),
              ),
              if (state is DoctorLogoutLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.18),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final DoctorProfile profile;

  const _ProfileHeader({required this.profile});

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
              _StatItem(value: profile.rating.toString(), label: 'Rating'),
              Container(width: 1, height: 40.h, color: Colors.grey[300]),
              _StatItem(value: profile.reviews.toString(), label: 'Reviews'),
              Container(width: 1, height: 40.h, color: Colors.grey[300]),
              _StatItem(
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

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Account',
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
          child: Column(
            children: [
              _SettingsItem(
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: 'Edit profile',
                onTap: () {},
              ),
              const _Divider(),
              _SettingsItem(
                icon: Icons.business_outlined,
                title: 'Clinic Information',
                subtitle: 'Medical Center',
                onTap: () {},
              ),
              const _Divider(),
              _SettingsItem(
                icon: Icons.star_outline,
                title: 'Specialization',
                subtitle: 'Cardiology',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Security',
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
          child: Column(
            children: [
              _SettingsItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                onTap: () {},
              ),
              const _Divider(),
              _SettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Enabled',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvailabilitySection extends StatelessWidget {
  final DoctorProfile profile;

  const _AvailabilitySection({required this.profile});

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
          child: _SettingsItem(
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

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Quick Actions',
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
          child: _SettingsItem(
            icon: Icons.star_border,
            iconColor: const Color(0xFFFFB74D),
            title: 'View My Reviews',
            onTap: () => context.push(AppRoutes.doctorReviewsPage),
          ),
        ),
      ],
    );
  }
}

class _DangerZoneSection extends StatelessWidget {
  const _DangerZoneSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Danger Zone',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: Icon(Icons.logout, size: 20.sp),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDeleteAccountDialog(context);
                  },
                  icon: Icon(Icons.delete_outline, size: 20.sp),
                  label: const Text('Delete Account'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD32F2F),
                    side: const BorderSide(color: Color(0xFFFFCDD2)),
                    backgroundColor: const Color(0xFFFFEBEE),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final parentContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              parentContext.read<DoctorLogoutCubit>().logOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add delete account logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: iconColor ?? Colors.grey[600],
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.sp),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      indent: 60.w,
      endIndent: 16.w,
      color: Colors.grey[200],
    );
  }
}
