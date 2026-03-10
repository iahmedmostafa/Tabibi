import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/appointment_card.dart';
import 'package:tabibi/features/doctor/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:tabibi/features/doctor/schedule/presentation/cubit/schedule_state.dart';

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
            ..getDoctorSchedule(_selectedDate.toUtc().toIso8601String()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Schedule', style: TextStyle(fontSize: 20.sp)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            SizedBox(height: 16.h),
            _buildDateTimeline(context),
            SizedBox(height: 24.h),
            Expanded(
              child: BlocBuilder<ScheduleCubit, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleLoading || state is ScheduleInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ScheduleError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ScheduleCubit>().getDoctorSchedule(
                                _selectedDate.toUtc().toIso8601String(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ScheduleLoaded) {
                    final appointments = state.appointments.map((apt) {
                      final timeStr =
                          "\${apt.appointmentDate.hour > 12 ? apt.appointmentDate.hour - 12 : apt.appointmentDate.hour == 0 ? 12 : apt.appointmentDate.hour}:\${apt.appointmentDate.minute.toString().padLeft(2, '0')} \${apt.appointmentDate.hour >= 12 ? 'PM' : 'AM'}";
                      final dateStr = DateFormat(
                        'MMM dd, yyyy',
                      ).format(apt.appointmentDate);
                      return Appointment(
                        id: apt.id,
                        patientName: apt.patientName,
                        patientId: '', // You can add it if API provides it
                        time: timeStr,
                        date: dateStr,
                        type: apt.type?.toString() ?? 'Consultation',
                        isUpcoming: apt.appointmentDate.isAfter(DateTime.now()),
                        location: '',
                        lastVisit: '',
                        allergies: '',
                        medications: '',
                      );
                    }).toList();

                    return Column(
                      children: [
                        _AppointmentsHeader(
                          count: appointments.length,
                          selectedDate: _selectedDate,
                        ),
                        SizedBox(height: 16.h),
                        Expanded(
                          child: appointments.isEmpty
                              ? const _EmptyState()
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  itemCount: appointments.length,
                                  itemBuilder: (context, index) {
                                    return AppointmentCard(
                                      appointment: appointments[index],
                                    );
                                  },
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

  Widget _buildDateTimeline(BuildContext context) {
    return Builder(
      builder: (context) {
        return EasyDateTimeLine(
          initialDate: _selectedDate,
          onDateChange: (selectedDate) {
            setState(() {
              _selectedDate = selectedDate;
            });
            context.read<ScheduleCubit>().getDoctorSchedule(
              selectedDate.toUtc().toIso8601String(),
            );
          },
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          dayProps: const EasyDayProps(
            dayStructure: DayStructure.dayStrDayNum,
            activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.blue600, AppColors.primary],
                ),
              ),
              dayNumStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              dayStrStyle: TextStyle(color: Colors.white, fontSize: 12),
            ),
            inactiveDayStyle: DayStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: AppColors.grey100,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppointmentsHeader extends StatelessWidget {
  final int count;
  final DateTime selectedDate;

  const _AppointmentsHeader({required this.count, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count appointments',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
              ),
              Text(
                DateFormat('EEEE, MMM d').format(selectedDate),
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.doctorAvailability),
            child: Text('Edit Availability', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'No appointments for this day',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
