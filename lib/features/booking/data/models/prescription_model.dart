import 'package:equatable/equatable.dart';

class MedicineModel extends Equatable {
  final String medicineName;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  const MedicineModel({
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      medicineName: json['medicineName'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? '',
      instructions: json['instructions'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    medicineName,
    dosage,
    frequency,
    duration,
    instructions,
  ];
}

class PrescriptionModel extends Equatable {
  final String id;
  final String diagnosis;
  final String? notes;
  final String createdAt;
  final List<MedicineModel> medicines;

  const PrescriptionModel({
    required this.id,
    required this.diagnosis,
    this.notes,
    required this.createdAt,
    required this.medicines,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      notes: json['notes'],
      createdAt: json['createdAt'] ?? '',
      medicines:
          (json['medicines'] as List?)
              ?.map((e) => MedicineModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [id, diagnosis, notes, createdAt, medicines];
}
