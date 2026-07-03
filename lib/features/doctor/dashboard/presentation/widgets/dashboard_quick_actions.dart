import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/animated_fade_slide.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/quick_action_item.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = DoctorLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedFadeSlide(
          offset: 16,
          child: Text(
            loc.quickActions,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        AnimatedFadeSlide(
          offset: 20,
          child: Row(
            children: [
              QuickActionItem(
                label: loc.schedule,
                icon: Icons.calendar_month,
                iconColor: AppColors.actionGreen,
                backgroundColor: AppColors.successLight,
                gradientColors: [
                  AppColors.successLight,
                  AppColors.successLight.withValues(alpha: 0.6),
                ],
                onTap: () => context.push(AppRoutes.doctorSchedule),
              ),
              SizedBox(width: 10.w),
              QuickActionItem(
                label: loc.requests,
                icon: Icons.pending_actions,
                iconColor: AppColors.blue,
                backgroundColor: AppColors.paleBlueLight,
                gradientColors: [
                  AppColors.paleBlueLight,
                  AppColors.paleBlueLight.withValues(alpha: 0.6),
                ],
                onTap: () => context.push(AppRoutes.doctorRequests),
              ),
              SizedBox(width: 10.w),
              QuickActionItem(
                label: loc.availability,
                icon: Icons.event_available,
                iconColor: AppColors.error,
                backgroundColor: AppColors.lightPink,
                gradientColors: [
                  AppColors.lightPink,
                  AppColors.lightPink.withValues(alpha: 0.6),
                ],
                onTap: () => context.push(AppRoutes.doctorAvailability),
              ),
              SizedBox(width: 10.w),
              QuickActionItem(
                label: loc.earnings,
                icon: Icons.attach_money,
                iconColor: AppColors.actionPurple,
                backgroundColor: AppColors.actionPinkLight,
                gradientColors: [
                  AppColors.actionPinkLight,
                  AppColors.actionPinkLight.withValues(alpha: 0.6),
                ],
                onTap: () => context.push(AppRoutes.doctorEarnings),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
