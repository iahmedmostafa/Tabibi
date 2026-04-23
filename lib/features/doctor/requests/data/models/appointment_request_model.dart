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
    // Determine status from integer (Assuming 0 = pending, 1 = scheduled, etc.)
    String mappedStatus = 'pending';
    if (json['status'] == 1) mappedStatus = 'approved';
    if (json['status'] == 2) mappedStatus = 'completed';
    if (json['status'] == 3) mappedStatus = 'rejected';

    return AppointmentRequestModel(
      id: json['id'] ?? '',
      patientName: json['patientName'] ?? 'Unknown Patient',
      imageUrl: json['patientAvatarUrl'] ?? '',
      dateTime: json['appointmentDate'] != null
          ? DateTime.tryParse(json['appointmentDate'].toString() + (json['appointmentDate'].toString().endsWith('Z') ? '' : 'Z'))?.toLocal() ?? DateTime.now()
          : DateTime.now(),
      // Use 'type' as reason or placeholder if null
      reason: (json['type'] == 1 || json['type'] == '1')
          ? 'Consultation'
          : (json['type'] == 2 || json['type'] == '2')
              ? 'Follow-up'
              : json['type']?.toString() ?? 'Consultation',
      status: mappedStatus,
    );
  }
}
