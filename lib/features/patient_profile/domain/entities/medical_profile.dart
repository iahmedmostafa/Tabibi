class MedicalProfile {
  final String patientId;
  final List<String> chronicDiseases;
  final String? medications;
  final String? allergies;
  final List<String> surgeries;
  final String? weight;
  final String? height;
  final bool isCompleted;
  final String updatedAt;

  const MedicalProfile({
    required this.patientId,
    required this.chronicDiseases,
    this.medications,
    this.allergies,
    required this.surgeries,
    this.weight,
    this.height,
    required this.isCompleted,
    required this.updatedAt,
  });
}
