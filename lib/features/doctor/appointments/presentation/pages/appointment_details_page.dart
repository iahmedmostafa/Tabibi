import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_cubit.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_state.dart';
import 'package:tabibi/features/doctor/appointments/presentation/mappers/appointment_patient_mapper.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_action_buttons.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_info_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_patient_info_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/prescription_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/reason_for_visit_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/view_patient_profile_button.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_loading_state.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_error_state.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          sl<AppointmentDetailsCubit>()..getAppointmentDetails(appointment.id),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'appointmentDetails'.tr(),
            style: theme.textTheme.titleLarge,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
          builder: (context, state) {
            if (state is AppointmentDetailsLoading ||
                state is AppointmentDetailsInitial) {
              return const DoctorLoadingState();
            }
            if (state is AppointmentDetailsError) {
              return DoctorErrorState(
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
                    ViewPatientProfileButton(
                      appointmentId: details.id,
                      patient: AppointmentPatientMapper.toDoctorPatient(
                        details.patient,
                      ),
                      appointmentDate: details.appointmentDate,
                      prescriptionWritePolicy: state.prescriptionWritePolicy,
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
                    if (isUpcoming || isCompleted)
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
