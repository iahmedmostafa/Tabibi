import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_cubit.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_state.dart';
import 'package:tabibi/features/doctor/appointments/presentation/mappers/appointment_patient_mapper.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_action_buttons.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_details_error_view.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_info_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_patient_info_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/prescription_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/reason_for_visit_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/view_patient_profile_button.dart';
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
              return AppointmentDetailsErrorView(
                message: state.message,
                onRetry: () => context
                    .read<AppointmentDetailsCubit>()
                    .getAppointmentDetails(appointment.id),
              );
            }
            if (state is AppointmentDetailsLoaded) {
              final details = state.appointmentDetails;

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    AppointmentPatientInfoCard(
                      patient: details.patient,
                      isUpcoming: state.isUpcoming,
                    ),
                    SizedBox(height: 16.h),
                    ViewPatientProfileButton(
                      appointmentId: details.id,
                      appointmentDate: details.appointmentDate,
                      patient: AppointmentPatientMapper.toDoctorPatient(
                        details.patient,
                      ),
                      prescriptionWritePolicy: state.prescriptionWritePolicy,
                    ),
                    SizedBox(height: 16.h),
                    AppointmentInfoCard(
                      details: details,
                      isUpcoming: state.isUpcoming,
                    ),
                    SizedBox(height: 16.h),
                    ReasonForVisitCard(details: details),
                    if (details.prescription != null) ...[
                      SizedBox(height: 16.h),
                      PrescriptionCard(prescription: details.prescription!),
                    ],
                    SizedBox(height: 24.h),
                    if (state.canManageAppointment)
                      AppointmentActionButtons(
                        patientId: details.patient.id,
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
