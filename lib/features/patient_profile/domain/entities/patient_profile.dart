class PatientProfileCity {
  final String id;
  final String name;

  const PatientProfileCity({required this.id, required this.name});
}

class PatientProfile {
  final String name;
  final String email;
  final String? avatarUrl;
  final int? gender;
  final String? dateOfBirth;
  final PatientProfileCity? city;
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
