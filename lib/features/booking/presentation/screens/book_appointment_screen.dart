import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/booking/presentation/controller/appointment_cubit.dart';
import 'package:tabibi/features/booking/presentation/widgets/booking_success_dialog.dart';
import 'package:tabibi/features/booking/presentation/widgets/booking_type_selection.dart';
import 'package:tabibi/features/booking/presentation/widgets/show_data_time.dart';
import 'package:tabibi/features/booking/presentation/widgets/time_slot_grid.dart';
import 'package:tabibi/features/doctor_details/data/models/doctor_details_model.dart';

class BookAppointmentScreen extends StatelessWidget {
  final DoctorDetailsModel doctor;
  const BookAppointmentScreen({super.key, required this.doctor});

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
            log(state.message);
            AppHelperFunctions.showAwesomeSnackBar(
              title: 'Error',
              message: state.message,
              contentType: ContentType.failure,
              context: context,
            );
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
                ShowDateTime(doctorId: doctor.id, schedule: doctor.schedule),
                SizedBox(height: 24.h),
                const BookingTypeSelection(),
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
                          context.read<AppointmentCubit>().bookAppointment(
                            doctorId: doctor.id,
                          );
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
