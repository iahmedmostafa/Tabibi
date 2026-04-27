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
  final statusValue = json['status']?.toString();

  String mappedStatus = 'pending';

  if (statusValue == '1') mappedStatus = 'approved';
  if (statusValue == '2') mappedStatus = 'completed';
  if (statusValue == '3') mappedStatus = 'rejected';

  return AppointmentRequestModel(
    id: json['id'] ?? '',
    patientName: json['patientName'] ?? 'Unknown Patient',
    imageUrl: json['patientAvatarUrl'] ?? '',
    dateTime: json['appointmentDate'] != null
        ? DateTime.tryParse(
              json['appointmentDate'].toString().endsWith('Z')
                  ? json['appointmentDate'].toString()
                  : '${json['appointmentDate']}Z',
            )?.toLocal() ??
            DateTime.now()
        : DateTime.now(),
    reason: (json['type'] == 1 || json['type'] == '1')
        ? 'Consultation'
        : (json['type'] == 2 || json['type'] == '2')
            ? 'Follow-up'
            : json['type']?.toString() ?? 'Consultation',
    status: mappedStatus,
  );
}
}
