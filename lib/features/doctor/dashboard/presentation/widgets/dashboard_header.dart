import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/animated_fade_slide.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';

class DashboardHeader extends StatelessWidget {
  final DashboardResponse data;

  const DashboardHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = DoctorLocalizations.of(context);
    final theme = Theme.of(context);
    final initials = data.doctorName.isNotEmpty && data.doctorName.length >= 2
        ? data.doctorName.substring(0, 2).toUpperCase()
        : 'DR';

    return AnimatedFadeSlide(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.welcomeBack,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.grey400 : AppColors.grey500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Dr. ${data.doctorName}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 26.r,
            backgroundColor: AppColors.primary,
            backgroundImage: data.doctorAvatarUrl != null
                ? NetworkImage(data.doctorAvatarUrl!)
                : null,
            child: data.doctorAvatarUrl == null
                ? Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
