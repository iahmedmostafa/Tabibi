import 'package:equatable/equatable.dart';

enum CreatePrescriptionStatus {
  initial,
  loading,
  success,
  failure,
  completionFailure,
  validationFailure,
  unavailable,
}

class PrescriptionMedicineFormInput extends Equatable {
  final String id;
  final String medicineName;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  const PrescriptionMedicineFormInput({
    this.id = 'medicine-0',
    this.medicineName = '',
    this.dosage = '',
    this.frequency = '',
    this.duration = '',
    this.instructions = '',
  });

  bool get isComplete =>
      medicineName.trim().isNotEmpty &&
      dosage.trim().isNotEmpty &&
      frequency.trim().isNotEmpty &&
      duration.trim().isNotEmpty &&
      instructions.trim().isNotEmpty;

  PrescriptionMedicineFormInput copyWith({
    String? medicineName,
    String? dosage,
    String? frequency,
    String? duration,
    String? instructions,
  }) {
    return PrescriptionMedicineFormInput(
      id: id,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  List<Object?> get props => [
    id,
    medicineName,
    dosage,
    frequency,
    duration,
    instructions,
  ];
}

class CreatePrescriptionState extends Equatable {
  final CreatePrescriptionStatus status;
  final String appointmentId;
  final String diagnosis;
  final String notes;
  final List<PrescriptionMedicineFormInput> medicines;
  final DateTime? appointmentDate;
  final String? errorMessage;

  const CreatePrescriptionState({
    this.status = CreatePrescriptionStatus.initial,
    this.appointmentId = '',
    this.diagnosis = '',
    this.notes = '',
    this.medicines = const [PrescriptionMedicineFormInput()],
    this.appointmentDate,
    this.errorMessage,
  });

  bool get isLoading => status == CreatePrescriptionStatus.loading;

  bool get hasAppointmentId => appointmentId.trim().isNotEmpty;

  bool get hasFailureFeedback =>
      status == CreatePrescriptionStatus.failure ||
      status == CreatePrescriptionStatus.completionFailure ||
      status == CreatePrescriptionStatus.validationFailure ||
      status == CreatePrescriptionStatus.unavailable;

  bool get isAppointmentAvailable {
    final scheduledAt = appointmentDate;
    return scheduledAt == null || !scheduledAt.isAfter(DateTime.now());
  }

  bool get canRemoveMedicine => medicines.length > 1;

  bool get canSubmit =>
      !isLoading &&
      hasAppointmentId &&
      isAppointmentAvailable &&
      diagnosis.trim().isNotEmpty &&
      medicines.isNotEmpty &&
      medicines.every((medicine) => medicine.isComplete);

  CreatePrescriptionState copyWith({
    CreatePrescriptionStatus? status,
    String? appointmentId,
    String? diagnosis,
    String? notes,
    List<PrescriptionMedicineFormInput>? medicines,
    DateTime? appointmentDate,
    String? errorMessage,
  }) {
    return CreatePrescriptionState(
      status: status ?? this.status,
      appointmentId: appointmentId ?? this.appointmentId,
      diagnosis: diagnosis ?? this.diagnosis,
      notes: notes ?? this.notes,
      medicines: medicines ?? this.medicines,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    appointmentId,
    diagnosis,
    notes,
    medicines,
    appointmentDate,
    errorMessage,
  ];
}
