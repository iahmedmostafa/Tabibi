import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/prescription_medicine.dart';

class CreatePrescriptionRequest extends Equatable {
  final String diagnosis;
  final String? notes;
  final List<PrescriptionMedicine> medicines;

  const CreatePrescriptionRequest({
    required this.diagnosis,
    this.notes,
    required this.medicines,
  });

  @override
  List<Object?> get props => [diagnosis, notes, medicines];
}
