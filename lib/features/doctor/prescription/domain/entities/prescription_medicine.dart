import 'package:equatable/equatable.dart';

class PrescriptionMedicine extends Equatable {
  final String medicineName;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  const PrescriptionMedicine({
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });

  @override
  List<Object?> get props => [
    medicineName,
    dosage,
    frequency,
    duration,
    instructions,
  ];
}
