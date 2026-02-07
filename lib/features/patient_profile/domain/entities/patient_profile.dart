class PatientProfile {
  final String name;
  final String email;
  final String? avatarUrl;
  final int? gender;
  final String? dateOfBirth;
  final String createdAtUtc;
  final String? updatedAtUtc;

  const PatientProfile({
    required this.name,
    required this.email,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    required this.createdAtUtc,
    this.updatedAtUtc,
  });
}
