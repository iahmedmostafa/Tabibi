class PatientProfile {
  final String name;
  final String email;
  final String? avatarUrl;
  final String? gender;
  final String? dateOfBirth;
  final String? city;
  final String createdAtUtc;
  final String? updatedAtUtc;

  const PatientProfile({
    required this.name,
    required this.email,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.city,
    required this.createdAtUtc,
    this.updatedAtUtc,
  });
}
