import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_cubit.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_state.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_action_buttons.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_details_error_view.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_info_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_patient_info_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/prescription_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/reason_for_visit_card.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AppointmentDetailsCubit>()..getAppointmentDetails(appointment.id),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Appointment Details',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
          builder: (context, state) {
            if (state is AppointmentDetailsLoading ||
                state is AppointmentDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AppointmentDetailsError) {
              return _AppointmentDetailsError(
                message: state.message,
                onRetry: () => context
                    .read<AppointmentDetailsCubit>()
                    .getAppointmentDetails(appointment.id),
              );
            }
            if (state is AppointmentDetailsLoaded) {
              final details = state.appointmentDetails;
              final isUpcoming = DoctorAppointmentStatus.isUpcoming(
                details.status,
              );
              final isCompleted = DoctorAppointmentStatus.isCompleted(
                details.status,
              );
            

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    AppointmentPatientInfoCard(
                      patient: details.patient,
                      status: details.status,
                    ),
                    SizedBox(height: 16.h),
                    AppointmentInfoCard(details: details),
                    SizedBox(height: 16.h),
                    ReasonForVisitCard(details: details),
                    if (details.prescription != null) ...[
                      SizedBox(height: 16.h),
                      PrescriptionCard(prescription: details.prescription!),
                    ],
                    SizedBox(height: 24.h),
                    if (isUpcoming||isCompleted)
                      AppointmentActionButtons(
                        patientId: details.patient.id,
                        bookingId: details.id,
                        patientName: details.patient.name,
                        patientImage: details.patient.avatarUrl,
                      ),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _AppointmentDetailsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AppointmentDetailsError({
    required this.message,
    required this.onRetry,
  });

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
