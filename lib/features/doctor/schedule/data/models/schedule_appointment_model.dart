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
          ? DateTime.tryParse(json['appointmentDate'].toString() + (json['appointmentDate'].toString().endsWith('Z') ? '' : 'Z'))?.toLocal() ?? DateTime.now()
          : DateTime.now(),
      type: (json['type'] == 1 || json['type'] == '1')
          ? 'Consultation'
          : (json['type'] == 2 || json['type'] == '2')
              ? 'Follow-up'
              : json['type']?.toString() ?? 'Consultation',
      status: json['status'],
    );
  }
}
