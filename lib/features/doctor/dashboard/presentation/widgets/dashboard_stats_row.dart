import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/stat_card.dart';

class DashboardStatsRow extends StatelessWidget {
  final DashboardStats stats;

  const DashboardStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final loc = DoctorLocalizations.of(context);
    return Row(
      children: [
        StatCard(
          label: loc.today,
          value: stats.todayCount.toString(),
          icon: Icons.calendar_today,
          iconColor: AppColors.blue,
          backgroundColor: AppColors.paleBlueLight,
          delayMilliseconds: 0,
        ),
        SizedBox(width: 12.w),
        StatCard(
          label: loc.done,
          value: stats.completedCount.toString(),
          icon: Icons.check_circle_outline,
          iconColor: AppColors.actionGreen,
          backgroundColor: AppColors.successLight,
          delayMilliseconds: 80,
        ),
        SizedBox(width: 12.w),
        StatCard(
          label: loc.refunded,
          value: stats.cancelledCount.toString(),
          icon: Icons.cancel_outlined,
          iconColor: AppColors.error,
          backgroundColor: AppColors.lightPink,
          delayMilliseconds: 160,
        ),
      ],
    );
  }
}
