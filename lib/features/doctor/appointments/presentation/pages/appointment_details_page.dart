import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_cubit.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_state.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_action_buttons.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_info_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_patient_info_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/prescription_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/reason_for_visit_card.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart'
    as doctor_patient;

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
              final isUpcoming = details.appointmentDate.isAfter(
                DateTime.now(),
              );
              final isCompleted = details.status == 3;
              final isCancelled = details.status == 4;
              final canManageAppointment =
                  isUpcoming && !isCompleted && !isCancelled;
              final canWritePrescription =
                  !isCompleted && !isCancelled && details.prescription == null;

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    AppointmentPatientInfoCard(
                      patient: details.patient,
                      isUpcoming: isUpcoming,
                    ),
                    SizedBox(height: 16.h),
                    _ViewPatientProfileButton(
                      appointmentId: details.id,
                      patient: _mapAppointmentPatient(details.patient),
                      canWritePrescription: canWritePrescription,
                    ),
                    SizedBox(height: 16.h),
                    AppointmentInfoCard(
                      details: details,
                      isUpcoming: isUpcoming,
                    ),
                    SizedBox(height: 16.h),
                    ReasonForVisitCard(details: details),
                    if (details.prescription != null) ...[
                      SizedBox(height: 16.h),
                      PrescriptionCard(prescription: details.prescription!),
                    ],
                    SizedBox(height: 24.h),
                    if (canManageAppointment)
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

  doctor_patient.Patient _mapAppointmentPatient(PatientEntity patient) {
    return doctor_patient.Patient(
      id: patient.id,
      name: patient.name,
      patientId: patient.id.isNotEmpty ? '#${patient.id}' : '#PATIENT',
      age: _calculateAge(patient.dateOfBirth),
      gender: _genderLabel(patient.gender),
      bloodGroup: 'Not specified',
      weight: 'Not specified',
      phone: 'Not specified',
      email: patient.email ?? 'Not specified',
      address: patient.city ?? 'Not specified',
      medicalHistory: const [],
      allergies: const [],
      previousVisits: const [],
    );
  }

  int _calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return 0;
    final now = DateTime.now();
    var age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  String _genderLabel(int? gender) {
    switch (gender) {
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      default:
        return 'Not specified';
    }
  }
}

class _ViewPatientProfileButton extends StatelessWidget {
  final String appointmentId;
  final doctor_patient.Patient patient;
  final bool canWritePrescription;

  const _ViewPatientProfileButton({
    required this.appointmentId,
    required this.patient,
    required this.canWritePrescription,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final completed = await context.pushNamed(
            AppRoutes.doctorPatientProfile,
            extra: {
              'patient': patient,
              'appointmentId': appointmentId,
              'canWritePrescription': canWritePrescription,
            },
          );
          if (completed == true && context.mounted) {
            context.read<AppointmentDetailsCubit>().getAppointmentDetails(
              appointmentId,
            );
          }
        },
        icon: Icon(Icons.person_search_outlined, size: 20.sp),
        label: const Text('View Patient Profile'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
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
