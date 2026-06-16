import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final DoctorProfileEntity profile;

  const ProfileHeader({super.key, required this.profile});

  String _getInitials(String name) {
    if (name.isEmpty) return 'DR';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 28.h),

          // Avatar with ring
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.tealDark.withValues(alpha: 0.3),
                      AppTheme.tealDark.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    color: AppTheme.tealDark,
                    shape: BoxShape.circle,
                    image: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(profile.avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: profile.avatarUrl == null || profile.avatarUrl!.isEmpty
                      ? Center(
                          child: Text(
                            _getInitials(profile.name),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.surface, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Name
          if (profile.name.isNotEmpty)
            Text(
              profile.name,
              style: TextStyle(
                fontSize: 21.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
          SizedBox(height: 4.h),

          // Department
          if (profile.department != null && profile.department!.name.isNotEmpty)
            Text(
              profile.department!.name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
            ),
          SizedBox(height: 4.h),

          // Email
          if (profile.email.isNotEmpty)
            Text(
              profile.email,
              style: TextStyle(
                fontSize: 12.sp,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

          SizedBox(height: 24.h),

          // Stats divider
          Divider(height: 1, indent: 24.w, endIndent: 24.w, color: theme.dividerColor.withValues(alpha: 0.5)),
          SizedBox(height: 16.h),

          // Stats Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: _StatChip(
                    value: profile.consultationFee.isNotEmpty ? '\$${profile.consultationFee}' : '--',
                    label: 'Fee',
                    color: AppTheme.blueIcon,
                    bgColor: AppTheme.bluePastel,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _StatChip(
                    value: profile.yearsOfExperience.isNotEmpty ? profile.yearsOfExperience : '--',
                    label: 'Years Exp.',
                    color: AppTheme.greenIcon,
                    bgColor: AppTheme.greenPastel,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _StatChip(
                    value: profile.gender == 1 ? 'Male' : 'Female',
                    label: 'Gender',
                    color: AppTheme.purpleIcon,
                    bgColor: AppTheme.purplePastel,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color bgColor;

  const _StatChip({
    required this.value,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.1) : bgColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? color : color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
