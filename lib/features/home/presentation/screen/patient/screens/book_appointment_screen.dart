import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/appointment_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/booking_success_dialog.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_calendar.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/time_slot_grid.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookAppointment),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentBookingSuccess) {
            showDialog(
              context: context,
              builder: (context) => const BookingSuccessDialog(),
            );
          } else if (state is AppointmentFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.selectDate,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                CustomCalendar(
                  onDateSelected: (date) {
                    context.read<AppointmentCubit>().selectDate(date);
                  },
                ),
                SizedBox(height: 24.h),
                Text(
                  AppStrings.selectHour,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                TimeSlotGrid(
                  onTimeSelected: (time) {
                    context.read<AppointmentCubit>().selectTime(time);
                  },
                ),
                SizedBox(height: 32.h),
                PrimaryButton(
                  title: state is AppointmentBookingLoading
                      ? AppStrings.booking
                      : AppStrings.confirm,
                  onPress: state is AppointmentReadyToBook
                      ? () {
                          context.read<AppointmentCubit>().bookAppointment();
                        }
                      : null, // Disable if not ready
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
