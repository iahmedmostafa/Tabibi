import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

class Appointment {
  final String id;
  final String patientName;
  final String patientId;
  final String time;
  final String date;
  final String type;
  final int status;
  final String location;
  final String lastVisit;
  final String allergies;
  final String medications;

  bool get isUpcoming => DoctorAppointmentStatus.isUpcoming(status);
  bool get isCompleted => DoctorAppointmentStatus.isCompleted(status);
  bool get isRefunded => DoctorAppointmentStatus.isRefunded(status);
  String get statusLabel => DoctorAppointmentStatus.label(status);

  Appointment({
    this.id = '1',
    required this.patientName,
    this.patientId = '#PAT-2847',
    required this.time,
    required this.date,
    required this.type,
    int? status,
    bool? isUpcoming,
    this.location = 'Medical Center, Room 204',
    this.lastVisit = 'Oct 15, 2025',
    this.allergies = 'Penicillin',
    this.medications = '2 Active',
  }) : status =
           status ??
           (isUpcoming == false
               ? DoctorAppointmentStatus.completed
               : DoctorAppointmentStatus.upcoming);
}
