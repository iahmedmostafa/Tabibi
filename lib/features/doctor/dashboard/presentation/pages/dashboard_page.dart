import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_quick_actions.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_requests_banner.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_stats_row.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_today_appointments.dart';

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
              }
              if (state is DashboardError) {
                return _DashboardError(
                  message: state.message,
                  onRetry: () =>
                      context.read<DashboardCubit>().getDoctorDashboard(),
                );
              }
              if (state is DashboardLoaded) {
                return _DashboardContent(data: state.dashboardData);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardResponse data;

  const _DashboardContent({required this.data});

  List<Appointment> _mapAppointments(DashboardResponse data) {
    return data.todayAppointments.map((apt) {
      final h = apt.appointmentDate.hour;
      final m = apt.appointmentDate.minute;
      final hour = h > 12 ? h - 12 : h == 0 ? 12 : h;
      final period = h >= 12 ? 'PM' : 'AM';
      return Appointment(
        id: apt.id,
        patientName: apt.patientName,
        time: '$hour:${m.toString().padLeft(2, '0')} $period',
        date: 'Today',
        type: apt.type?.toString() ?? 'Consultation',
        isUpcoming: apt.appointmentDate.isAfter(DateTime.now()),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appointments = _mapAppointments(data);

    return RefreshIndicator(
      onRefresh: () =>
          context.read<DashboardCubit>().getDoctorDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(data: data),
            const SizedBox(height: 24),
            DashboardStatsRow(stats: data.stats),
            const SizedBox(height: 32),
            const DashboardQuickActions(),
            const SizedBox(height: 32),
            DashboardTodayAppointments(appointments: appointments),
            const SizedBox(height: 16),
            const DashboardRequestsBanner(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
