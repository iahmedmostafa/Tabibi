import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor != Colors.transparent
        ? theme.cardColor
        : theme.colorScheme.surface;

    return GestureDetector(
      onTap: () =>
          context.push(AppRoutes.doctorAppointmentDetails, extra: appointment),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with initials fallback
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_outline,
                color: theme.colorScheme.onSurfaceVariant,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appointment.patientName,
                        style: theme.textTheme.titleMedium,
                      ),
                      if (appointment.isUpcoming)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.bluePastel,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Upcoming',
                            style: TextStyle(
                              color: AppTheme.blueIcon,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.greenPastel,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Completed',
                            style: TextStyle(
                              color: AppTheme.greenIcon,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.grey400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${appointment.time} • ${appointment.date}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appointment.type,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
