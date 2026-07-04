import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/appointment_card.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/doctor/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:tabibi/features/doctor/schedule/presentation/cubit/schedule_state.dart';
import 'package:tabibi/features/doctor/schedule/presentation/widgets/schedule_appointments_header.dart';
import 'package:tabibi/features/doctor/schedule/presentation/widgets/schedule_date_timeline.dart';
import 'package:tabibi/features/doctor/schedule/presentation/widgets/schedule_empty_state.dart';
import 'package:easy_localization/easy_localization.dart';

class MySchedulePage extends StatefulWidget {
  final bool showBottomNav;

  const MySchedulePage({super.key, this.showBottomNav = true});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = DoctorLocalizations.of(context);

    return BlocProvider(
      create: (context) =>
          sl<ScheduleCubit>()
            ..getDoctorSchedule(_selectedDate.toIso8601String()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(loc.mySchedule, style: theme.textTheme.titleLarge),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
        ),
        body: Column(
          children: [
            SizedBox(height: 16.h),
            ScheduleDateTimeline(
              selectedDate: _selectedDate,
              onDateChange: (date) {
                setState(() => _selectedDate = date);
              },
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: BlocBuilder<ScheduleCubit, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleLoading || state is ScheduleInitial) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.midnightBlue,
                        strokeWidth: 2.5,
                      ),
                    );
                  }
                  if (state is ScheduleError) {
                    return _ScheduleError(
                      message: state.message,
                      onRetry: () => context
                          .read<ScheduleCubit>()
                          .getDoctorSchedule(_selectedDate.toIso8601String()),
                    );
                  }
                  if (state is ScheduleLoaded) {
                    final appointments = _mapAppointments(state);
                    return Column(
                      children: [
                        ScheduleAppointmentsHeader(
                          count: appointments.length,
                          selectedDate: _selectedDate,
                        ),
                        SizedBox(height: 16.h),
                        Expanded(
                          child: appointments.isEmpty
                              ? const ScheduleEmptyState()
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  itemCount: appointments.length,
                                  itemBuilder: (context, index) =>
                                      AppointmentCard(
                                        appointment: appointments[index],
                                      ),
                                ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Appointment> _mapAppointments(ScheduleLoaded state) {
    return state.appointments.map((apt) {
      final localDateTime = apt.appointmentDate.toLocal();
      final h = localDateTime.hour;
      final m = localDateTime.minute;
      final hour = h > 12
          ? h - 12
          : h == 0
          ? 12
          : h;
      final period = h >= 12 ? 'PM'.tr() : 'AM'.tr();
      return Appointment(
        id: apt.id,
        patientName: apt.patientName,
        time: '$hour:${m.toString().padLeft(2, '0')} $period',
        date: DateFormat('MMM dd, yyyy').format(localDateTime),
        type: apt.type?.toString() ?? 'consultation'.tr(),
        status: DoctorAppointmentStatus.fromJson(apt.status),
      );
    }).toList();
  }
}

class _ScheduleError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ScheduleError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.sp,
            color: isDark ? Colors.red.shade400 : Colors.red.shade600,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              color: isDark ? AppColors.grey400 : AppColors.grey600,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text('retry'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.midnightBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
