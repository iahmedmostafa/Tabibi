import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

class AppointmentRequest extends Equatable {
  final String id;
  final String patientName;
  final String imageUrl; // For placeholder or real image
  final DateTime dateTime;
  final String reason;
  final int status;

  const AppointmentRequest({
    required this.id,
    required this.patientName,
    this.imageUrl = '',
    required this.dateTime,
    required this.reason,
    this.status = DoctorAppointmentStatus.upcoming,
  });

  bool get isUpcoming => DoctorAppointmentStatus.isUpcoming(status);
  bool get isCompleted => DoctorAppointmentStatus.isCompleted(status);
  bool get isRefunded => DoctorAppointmentStatus.isRefunded(status);
  String get statusLabel => DoctorAppointmentStatus.label(status);

  AppointmentRequest copyWith({
    String? id,
    String? patientName,
    String? imageUrl,
    DateTime? dateTime,
    String? reason,
    int? status,
  }) {
    return AppointmentRequest(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      imageUrl: imageUrl ?? this.imageUrl,
      dateTime: dateTime ?? this.dateTime,
      reason: reason ?? this.reason,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    patientName,
    imageUrl,
    dateTime,
    reason,
    status,
  ];
}
