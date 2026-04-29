import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/stat_card.dart';

class DashboardStatsRow extends StatelessWidget {
  final DashboardStats stats;

  const DashboardStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatCard(
          label: 'Today',
          value: stats.todayCount.toString(),
          icon: Icons.calendar_today,
          iconColor: AppTheme.blueIcon,
          backgroundColor: AppTheme.bluePastel,
        ),
        const SizedBox(width: 12),
        StatCard(
          label: 'Done',
          value: stats.completedCount.toString(),
          icon: Icons.check_circle_outline,
          iconColor: AppTheme.greenIcon,
          backgroundColor: AppTheme.greenPastel,
        ),
        const SizedBox(width: 12),
        StatCard(
          label: 'Refunded',
          value: stats.cancelledCount.toString(),
          icon: Icons.cancel_outlined,
          iconColor: AppTheme.redIcon,
          backgroundColor: AppTheme.redPastel,
        ),
      ],
    );
  }
}
