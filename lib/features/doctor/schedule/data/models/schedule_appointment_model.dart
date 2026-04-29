import 'package:tabibi/core/utils/backend_date_time.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/schedule_appointment.dart';

class ScheduleAppointmentModel extends ScheduleAppointment {
  const ScheduleAppointmentModel({
    required super.id,
    required super.patientName,
    super.patientAvatarUrl,
    required super.appointmentDate,
    required super.type,
    required super.status,
  });

  factory ScheduleAppointmentModel.fromJson(Map<String, dynamic> json) {
    return ScheduleAppointmentModel(
      id: json['id'] ?? '',
      patientName: json['patientName'] ?? '',
      patientAvatarUrl: json['patientAvatarUrl'],
      appointmentDate: json['appointmentDate'] != null
          ? BackendDateTime.tryParseUtc(json['appointmentDate'] as String) ??
                DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      type: json['type'],
      status: DoctorAppointmentStatus.fromJson(json['status']),
    );
  }
}
