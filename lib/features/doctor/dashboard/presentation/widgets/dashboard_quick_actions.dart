import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/quick_action_item.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.doctorQuickActions, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Row(
          children: [
            QuickActionItem(
              label: 'Schedule',
              icon: Icons.calendar_month,
              iconColor: AppTheme.greenIcon,
              backgroundColor: AppTheme.greenPastel,
              onTap: () => context.push(AppRoutes.doctorSchedule),
            ),
            const SizedBox(width: 10),
            QuickActionItem(
              label: 'Requests',
              icon: Icons.pending_actions,
              iconColor: AppTheme.blueIcon,
              backgroundColor: AppTheme.bluePastel,
              onTap: () => context.push(AppRoutes.doctorRequests),
            ),
            const SizedBox(width: 10),
            QuickActionItem(
              label: 'Availability',
              icon: Icons.event_available,
              iconColor: AppTheme.redIcon,
              backgroundColor: AppTheme.redPastel,
              onTap: () => context.push(AppRoutes.doctorAvailability),
            ),
            const SizedBox(width: 10),
            QuickActionItem(
              label: AppStrings.doctorEarnings,
              icon: Icons.attach_money,
              iconColor: AppTheme.purpleIcon,
              backgroundColor: AppTheme.purplePastel,
              onTap: () => context.push(AppRoutes.doctorEarnings),
            ),
          ],
        ),
      ],
    );
  }
}
