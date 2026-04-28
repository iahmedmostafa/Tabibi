import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/appointment_card.dart';
import 'package:tabibi/features/doctor/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:tabibi/features/doctor/schedule/presentation/cubit/schedule_state.dart';
import 'package:tabibi/features/doctor/schedule/presentation/widgets/schedule_appointments_header.dart';
import 'package:tabibi/features/doctor/schedule/presentation/widgets/schedule_date_timeline.dart';
import 'package:tabibi/features/doctor/schedule/presentation/widgets/schedule_empty_state.dart';

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
    return BlocProvider(
      create: (context) =>
          sl<ScheduleCubit>()
            ..getDoctorSchedule(_selectedDate.toIso8601String()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Schedule', style: TextStyle(fontSize: 20.sp)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            SizedBox(height: 16.h),
            ScheduleDateTimeline(
              selectedDate: _selectedDate,
              onDateChange: (date) => setState(() => _selectedDate = date),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: BlocBuilder<ScheduleCubit, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleLoading || state is ScheduleInitial) {
                    return const Center(child: CircularProgressIndicator());
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
      final period = h >= 12 ? 'PM' : 'AM';
      return Appointment(
        id: apt.id,
        patientName: apt.patientName,
        time: '$hour:${m.toString().padLeft(2, '0')} $period',
        date: DateFormat('MMM dd, yyyy').format(localDateTime),
        type: apt.type?.toString() ?? 'Consultation',
        isUpcoming: apt.appointmentDate.toUtc().isAfter(DateTime.now().toUtc()),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          SizedBox(height: 16.h),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
