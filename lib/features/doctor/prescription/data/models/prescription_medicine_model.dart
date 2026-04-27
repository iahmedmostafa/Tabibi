import 'package:tabibi/features/doctor/prescription/domain/entities/prescription_medicine.dart';

class PrescriptionMedicineModel extends PrescriptionMedicine {
  const PrescriptionMedicineModel({
    required super.medicineName,
    required super.dosage,
    required super.frequency,
    required super.duration,
    required super.instructions,
  });

  factory PrescriptionMedicineModel.fromEntity(PrescriptionMedicine medicine) {
    return PrescriptionMedicineModel(
      medicineName: medicine.medicineName,
      dosage: medicine.dosage,
      frequency: medicine.frequency,
      duration: medicine.duration,
      instructions: medicine.instructions,
    );
  }

  factory PrescriptionMedicineModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionMedicineModel(
      medicineName: json['medicineName'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? '',
      instructions: json['instructions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
    };
  }
}
