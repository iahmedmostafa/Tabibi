import 'package:tabibi/core/utils/backend_date_time.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

class AppointmentDetailsModel extends AppointmentDetailsEntity {
  const AppointmentDetailsModel({
    required super.id,
    required super.appointmentDate,
    required super.type,
    required super.status,
    required super.patient,
    super.prescription,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailsModel(
      id: json['id'] ?? '',
      appointmentDate: json['appointmentDate'] != null
          ? BackendDateTime.tryParseUtc(json['appointmentDate'] as String) ??
                DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      type: json['type'] ?? 0,
      status: DoctorAppointmentStatus.fromJson(json['status']),
      patient: PatientModel.fromJson(json['patient'] ?? {}),
      prescription: json['prescription'] != null
          ? PrescriptionModel.fromJson(json['prescription'])
          : null,
    );
  }
}

class PatientModel extends PatientEntity {
  const PatientModel({
    required super.id,
    required super.name,
    super.email,
    super.avatarUrl,
    super.gender,
    super.dateOfBirth,
    super.city,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      city: json['city'],
    );
  }
}

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.diagnosis,
    super.notes,
    required super.createdAt,
    required super.medicines,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? BackendDateTime.tryParseUtc(json['createdAt'] as String) ??
                DateTime.now().toUtc()
          : DateTime.now(),
      medicines: (json['medicines'] as List?)
              ?.map((e) => MedicineDetailsModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class MedicineDetailsModel extends MedicineEntity {
  const MedicineDetailsModel({
    required super.medicineName,
    required super.dosage,
    required super.frequency,
    required super.duration,
    required super.instructions,
  });

  factory MedicineDetailsModel.fromJson(Map<String, dynamic> json) {
    return MedicineDetailsModel(
      medicineName: json['medicineName'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? '',
      instructions: json['instructions'] ?? '',
    );
  }
}
