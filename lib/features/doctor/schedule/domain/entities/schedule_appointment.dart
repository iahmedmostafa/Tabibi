import 'package:equatable/equatable.dart';

class ScheduleAppointment extends Equatable {
  final String id;
  final String patientName;
  final String? patientAvatarUrl;
  final DateTime appointmentDate;
  final dynamic type;
  final dynamic status;

  const ScheduleAppointment({
    required this.id,
    required this.patientName,
    this.patientAvatarUrl,
    required this.appointmentDate,
    required this.type,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    patientName,
    patientAvatarUrl,
    appointmentDate,
    type,
    status,
  ];
}
