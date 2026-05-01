import 'package:tabibi/core/utils/helper/backend_date_time.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';

class AppointmentRequestModel extends AppointmentRequest {
  const AppointmentRequestModel({
    required super.id,
    required super.patientName,
    super.imageUrl,
    required super.dateTime,
    required super.reason,
    super.status,
  });

  factory AppointmentRequestModel.fromJson(Map<String, dynamic> json) {
    return AppointmentRequestModel(
      id: json['id'] ?? '',
      patientName: json['patientName'] ?? 'Unknown Patient',
      imageUrl: json['patientAvatarUrl'] ?? '',
      dateTime: json['appointmentDate'] != null
          ? BackendDateTime.tryParseUtc(json['appointmentDate'] as String) ??
                DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      reason: json['type'] == 1 ? 'Video Call' : 'Consultation',
      status: DoctorAppointmentStatus.fromJson(json['status']),
    );
  }
}
