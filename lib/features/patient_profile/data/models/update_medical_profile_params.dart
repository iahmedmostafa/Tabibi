class UpdateMedicalProfileParams {
  final List<String> chronicDiseases;
  final String? medications;
  final String? allergies;
  final List<String> surgeries;
  final String weight;
  final String height;

  const UpdateMedicalProfileParams({
    required this.chronicDiseases,
    required this.medications,
    required this.allergies,
    required this.surgeries,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      'chronicDiseases': chronicDiseases,
      'medications': medications,
      'allergies': allergies,
      'surgeries': surgeries,
      'weight': weight,
      'height': height,
    };
  }
}
