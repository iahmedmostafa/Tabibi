import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_loading_state.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_error_state.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_quick_actions.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_requests_banner.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_stats_row.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/dashboard_today_appointments.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

class DashboardPage extends StatelessWidget {
  final bool showBottomNav;

  const DashboardPage({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => sl<DashboardCubit>()..getDoctorDashboard(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading || state is DashboardInitial) {
                return const DoctorLoadingState();
              }
              if (state is DashboardError) {
                return DoctorErrorState(
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

class _DashboardContent extends StatelessWidget {
  final DashboardResponse data;

  const _DashboardContent({required this.data});

  List<Appointment> _mapAppointments(DashboardResponse data) {
    return data.todayAppointments.map((apt) {
      final localDateTime = apt.appointmentDate.toLocal();
      final h = localDateTime.hour;
      final m = localDateTime.minute;
      final hour = h > 12
          ? h - 12
          : h == 0
          ? 12
          : h;
      final period = h >= 12 ? 'PM' : 'AM';
      return Appointment(
        id: apt.id,
        patientName: apt.patientName,
        time: '$hour:${m.toString().padLeft(2, '0')} $period',
        date: 'Today',
        type: apt.type?.toString() ?? 'Consultation',
        status: DoctorAppointmentStatus.fromJson(apt.status),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appointments = _mapAppointments(data);

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [AppColors.darkBackground, AppColors.darkBackground]
                    : [
                        AppColors.paleBlue.withValues(alpha: 0.3),
                        AppColors.white,
                        AppColors.grey50,
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -60,
          right: -40,
          child: Container(
            width: 180.r,
            height: 180.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(isDark ? 0.10 : 0.08),
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: -70,
          child: Container(
            width: 140.r,
            height: 140.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.actionGreen.withOpacity(isDark ? 0.06 : 0.05),
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().getDoctorDashboard(),
          color: theme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeader(data: data),
                SizedBox(height: 24.h),
                DashboardStatsRow(stats: data.stats),
                SizedBox(height: 32.h),
                const DashboardQuickActions(),
                SizedBox(height: 32.h),
                DashboardTodayAppointments(appointments: appointments),
                SizedBox(height: 16.h),
                const DashboardRequestsBanner(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
