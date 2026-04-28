import 'package:tabibi/core/utils/backend_date_time.dart';
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
    // Determine status from integer (Assuming 0 = pending, 1 = scheduled, etc.) 3ashan mesh aref mohammed 3amel7a eh ya hamed ya a5oya😂
    String mappedStatus = 'pending';
    if (json['status'] == 1) mappedStatus = 'approved';
    if (json['status'] == 2) mappedStatus = 'completed';
    if (json['status'] == 3) mappedStatus = 'rejected';

    return AppointmentRequestModel(
      id: json['id'] ?? '',
      patientName: json['patientName'] ?? 'Unknown Patient',
      imageUrl: json['patientAvatarUrl'] ?? '',
      dateTime: json['appointmentDate'] != null
          ? BackendDateTime.tryParseUtc(json['appointmentDate'] as String) ??
                DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      reason: json['type']?.toString() ?? 'Consultation',
      status: mappedStatus,
    );
  }
}
