import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/prescription/presentation/policies/prescription_write_policy.dart';

abstract class AppointmentDetailsState extends Equatable {
  const AppointmentDetailsState();

  @override
  List<Object?> get props => [];
}

class AppointmentDetailsInitial extends AppointmentDetailsState {}

class AppointmentDetailsLoading extends AppointmentDetailsState {}

class AppointmentDetailsLoaded extends AppointmentDetailsState {
  final AppointmentDetailsEntity appointmentDetails;

  const AppointmentDetailsLoaded(this.appointmentDetails);

  bool get isUpcoming => appointmentDetails.appointmentDate.isAfter(
    DateTime.now(),
  );

  bool get isCompleted => appointmentDetails.status == 3;

  bool get isCancelled => appointmentDetails.status == 4;

  bool get canManageAppointment => isUpcoming && !isCompleted && !isCancelled;

  PrescriptionWritePolicy get prescriptionWritePolicy =>
      PrescriptionWritePolicy.evaluate(
        appointmentDate: appointmentDetails.appointmentDate,
        appointmentStatus: appointmentDetails.status,
        hasPrescription: appointmentDetails.prescription != null,
      );

  @override
  List<Object?> get props => [appointmentDetails];
}

class AppointmentDetailsError extends AppointmentDetailsState {
  final String message;

  const AppointmentDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
