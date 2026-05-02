import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/appointment_card.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/core/animations/fade_in_slide.dart';

class DashboardTodayAppointments extends StatelessWidget {
  final List<Appointment> appointments;

  const DashboardTodayAppointments({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.doctorTodayAppointments,
              style: theme.textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.doctorRequests),
              child: const Text(
                AppStrings.doctorSeeAll,
                style: TextStyle(color: AppTheme.tealDark),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (appointments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.event_busy,
                    size: 48,
                    color: AppColors.grey300,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.doctorNoAppointmentsToday,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
        else
          ...appointments.asMap().entries.map(
            (entry) => FadeInSlide(
              delay: Duration(milliseconds: 100 * entry.key),
              child: AppointmentCard(appointment: entry.value),
            ),
          ),
      ],
    );
  }
}
