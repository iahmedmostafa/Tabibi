import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_cubit.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_state.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/widgets/appointment_card.dart';
import 'package:tabibi/features/doctor/schedule/presentation/widgets/date_strip.dart';

class MySchedulePage extends StatelessWidget {
  final bool showBottomNav;

  const MySchedulePage({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    // Mock appointments (will be replaced with API data)
    final appointments = [
      Appointment(
        patientName: 'Sarah Johnson',
        time: '09:00 AM',
        date: 'Nov 15, 2025',
        type: 'Regular checkup and blood pressure...',
        isUpcoming: true,
      ),
      Appointment(
        patientName: 'Michael Chen',
        time: '10:30 AM',
        date: 'Nov 15, 2025',
        type: 'Follow-up consultation for diabetes...',
        isUpcoming: true,
      ),
      Appointment(
        patientName: 'Emily Parker',
        time: '02:00 PM',
        date: 'Nov 15, 2025',
        type: 'Annual physical examination',
        isUpcoming: false, // Completed
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Schedule', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const _MonthSelector(),
          SizedBox(height: 16.h),
          const _ViewToggle(),
          SizedBox(height: 24.h),
          const DateStrip(),
          SizedBox(height: 24.h),
          _AppointmentsHeader(count: appointments.length),
          SizedBox(height: 16.h),
          Expanded(
            child: appointments.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      return AppointmentCard(appointment: appointments[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailabilityCubit, AvailabilityState>(
      buildWhen: (previous, current) =>
          previous.selectedDate != current.selectedDate,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, size: 24.sp),
                onPressed: () =>
                    context.read<AvailabilityCubit>().changeMonth(-1),
              ),
              Text(
                DateFormat('MMMM yyyy').format(state.selectedDate),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, size: 24.sp),
                onPressed: () =>
                    context.read<AvailabilityCubit>().changeMonth(1),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Week',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final cubit = context.read<AvailabilityCubit>();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: cubit.state.selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialDatePickerMode: DatePickerMode.day,
                );
                if (picked != null) {
                  cubit.selectDate(picked);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  'Month',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentsHeader extends StatelessWidget {
  final int count;

  const _AppointmentsHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailabilityCubit, AvailabilityState>(
      buildWhen: (previous, current) =>
          previous.selectedDate != current.selectedDate,
      builder: (context, state) {
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
                    DateFormat('EEEE, MMM d').format(state.selectedDate),
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.doctorAvailability),
                child: Text(
                  'Edit Availability',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
        );
      },
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
