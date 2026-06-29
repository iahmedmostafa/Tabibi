import '../../domain/entities/medical_profile.dart';

class MedicalProfileModel extends MedicalProfile {
  const MedicalProfileModel({
    required super.patientId,
    required super.chronicDiseases,
    super.medications,
    super.allergies,
    required super.surgeries,
    super.weight,
    super.height,
    required super.isCompleted,
    required super.updatedAt,
  });

  factory MedicalProfileModel.fromJson(Map<String, dynamic> json) {
    return MedicalProfileModel(
      patientId: json['patientId'] ?? '',
      chronicDiseases: List<String>.from(json['chronicDiseases'] ?? []),
      medications: json['medications'],
      allergies: json['allergies'],
      surgeries: List<String>.from(json['surgeries'] ?? []),
      weight: json['weight']?.toString(),
      height: json['height']?.toString(),
      isCompleted: json['isCompleted'] ?? false,
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
