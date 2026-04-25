import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';

class DashboardHeader extends StatelessWidget {
  final DashboardResponse data;

  const DashboardHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = data.doctorName.isNotEmpty && data.doctorName.length >= 2
        ? data.doctorName.substring(0, 2).toUpperCase()
        : 'DR';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Dr. ${data.doctorName}', style: theme.textTheme.headlineMedium),
          ],
        ),
        CircleAvatar(
          radius: 26,
          backgroundColor: AppTheme.tealDark,
          backgroundImage: data.doctorAvatarUrl != null
              ? NetworkImage(data.doctorAvatarUrl!)
              : null,
          child: data.doctorAvatarUrl == null
              ? Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
      ],
    );
  }
}
