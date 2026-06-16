import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';
import 'package:tabibi/core/animations/fade_in_slide.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/stat_card.dart';

class DashboardStatsRow extends StatelessWidget {
  final DashboardStats stats;

  const DashboardStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FadeInSlide(
          delay: const Duration(milliseconds: 100),
          child: StatCard(
            label: 'Today',
            value: stats.todayCount.toString(),
            icon: Icons.calendar_today,
            iconColor: AppTheme.blueIcon,
            backgroundColor: AppTheme.blueIcon.withValues(alpha: 0.15),
          ),
        ),
        const SizedBox(width: 12),
        FadeInSlide(
          delay: const Duration(milliseconds: 200),
          child: StatCard(
            label: 'Done',
            value: stats.completedCount.toString(),
            icon: Icons.check_circle_outline,
            iconColor: AppTheme.greenIcon,
            backgroundColor: AppTheme.greenIcon.withValues(alpha: 0.15),
          ),
        ),
        const SizedBox(width: 12),
        FadeInSlide(
          delay: const Duration(milliseconds: 300),
          child: StatCard(
            label: 'Refunded',
            value: stats.cancelledCount.toString(),
            icon: Icons.cancel_outlined,
            iconColor: AppTheme.redIcon,
            backgroundColor: AppTheme.redIcon.withValues(alpha: 0.15),
          ),
        ),
      ],
    );
  }
}
