import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/appointment_card.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/quick_action_item.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  final bool showBottomNav;

  const DashboardPage({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardCubit>()..getDoctorDashboard(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading || state is DashboardInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DashboardError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.grey400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<DashboardCubit>()
                                .getDoctorDashboard();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is DashboardLoaded) {
                final data = state.dashboardData;
                final initials =
                    data.doctorName.isNotEmpty && data.doctorName.length >= 2
                    ? data.doctorName.substring(0, 2).toUpperCase()
                    : 'DR';

                final appointments = data.todayAppointments.map((apt) {
                  final h = apt.appointmentDate.hour;
                  final m = apt.appointmentDate.minute;
                  final hour = h > 12 ? h - 12 : h == 0 ? 12 : h;
                  final period = h >= 12 ? 'PM' : 'AM';
                  final timeStr =
                      '$hour:${m.toString().padLeft(2, '0')} $period';
                  return Appointment(
                    id: apt.id,
                    patientName: apt.patientName,
                    time: timeStr,
                    date: 'Today',
                    type: apt.type?.toString() ?? 'Consultation',
                    isUpcoming: apt.appointmentDate.isAfter(DateTime.now()),
                  );
                }).toList();

                final theme = Theme.of(context);

                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<DashboardCubit>().getDoctorDashboard(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Dr. ${data.doctorName}',
                                  style: theme.textTheme.headlineMedium,
                                ),
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
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            StatCard(
                              label: 'Today',
                              value: data.stats.todayCount.toString(),
                              icon: Icons.calendar_today,
                              iconColor: AppTheme.blueIcon,
                              backgroundColor: AppTheme.bluePastel,
                            ),
                            const SizedBox(width: 12),
                            StatCard(
                              label: 'Done',
                              value: data.stats.completedCount.toString(),
                              icon: Icons.check_circle_outline,
                              iconColor: AppTheme.greenIcon,
                              backgroundColor: AppTheme.greenPastel,
                            ),
                            const SizedBox(width: 12),
                            StatCard(
                              label: 'Cancelled',
                              value: data.stats.cancelledCount.toString(),
                              icon: Icons.cancel_outlined,
                              iconColor: AppTheme.redIcon,
                              backgroundColor: AppTheme.redPastel,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Quick Actions',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            QuickActionItem(
                              label: 'Schedule',
                              icon: Icons.calendar_month,
                              iconColor: AppTheme.greenIcon,
                              backgroundColor: AppTheme.greenPastel,
                              onTap: () =>
                                  context.push(AppRoutes.doctorSchedule),
                            ),
                            const SizedBox(width: 10),
                            QuickActionItem(
                              label: 'Requests',
                              icon: Icons.pending_actions,
                              iconColor: AppTheme.blueIcon,
                              backgroundColor: AppTheme.bluePastel,
                              onTap: () =>
                                  context.push(AppRoutes.doctorRequests),
                            ),
                            const SizedBox(width: 10),
                            QuickActionItem(
                              label: 'Availability',
                              icon: Icons.event_available,
                              iconColor: AppTheme.redIcon,
                              backgroundColor: AppTheme.redPastel,
                              onTap: () =>
                                  context.push(AppRoutes.doctorAvailability),
                            ),
                            const SizedBox(width: 10),
                            QuickActionItem(
                              label: 'Earnings',
                              icon: Icons.attach_money,
                              iconColor: AppTheme.purpleIcon,
                              backgroundColor: AppTheme.purplePastel,
                              onTap: () =>
                                  context.push(AppRoutes.doctorEarnings),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today's Appointments",
                              style: theme.textTheme.titleLarge,
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.push(AppRoutes.doctorSchedule),
                              child: const Text(
                                'See All',
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
                                    'No appointments today',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...appointments.map(
                            (apt) => AppointmentCard(appointment: apt),
                          ),

                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () =>
                              context.push(AppRoutes.doctorRequests),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppTheme.tealDark,
                                  Color(0xFF0A7871),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.pending_actions,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Appointment Requests',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'View & manage',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
