import 'package:equatable/equatable.dart';

class AppointmentDetailsEntity extends Equatable {
  final String id;
  final DateTime appointmentDate;
  final int type;
  final int status;
  final PatientEntity patient;
  final PrescriptionEntity? prescription;

  const AppointmentDetailsEntity({
    required this.id,
    required this.appointmentDate,
    required this.type,
    required this.status,
    required this.patient,
    this.prescription,
  });

  @override
  List<Object?> get props => [
        id,
        appointmentDate,
        type,
        status,
        patient,
        prescription,
      ];
}

class PatientEntity extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;
  final int? gender;
  final DateTime? dateOfBirth;
  final String? city;

  const PatientEntity({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.city,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        gender,
        dateOfBirth,
        city,
      ];
}

class PrescriptionEntity extends Equatable {
  final String id;
  final String diagnosis;
  final String? notes;
  final DateTime createdAt;
  final List<dynamic> medicines; 

  const PrescriptionEntity({
    required this.id,
    required this.diagnosis,
    this.notes,
    required this.createdAt,
    required this.medicines,
  });

  @override
  List<Object?> get props => [
        id,
        diagnosis,
        notes,
        createdAt,
        medicines,
      ];
}
