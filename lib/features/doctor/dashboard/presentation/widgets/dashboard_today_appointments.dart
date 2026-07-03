import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/appointment_card.dart';

class DashboardTodayAppointments extends StatelessWidget {
  final List<Appointment> appointments;

  const DashboardTodayAppointments({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = DoctorLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.todayAppointments,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.doctorRequests),
              child: Text(
                loc.seeAll,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        if (appointments.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.event_busy_rounded,
                    size: 48.sp,
                    color: isDark ? AppColors.grey700 : AppColors.grey300,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    loc.noAppointmentsToday,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.grey400 : AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...appointments.map(
            (apt) => AppointmentCard(appointment: apt),
          ),
      ],
    );
  }
}
