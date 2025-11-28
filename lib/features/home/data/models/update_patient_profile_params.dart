class UpdatePatientProfileParams {
  final String? name;
  final String? cityId;
  final String? avatarUrl;
  final int? gender;
  final String? dateOfBirth;

  const UpdatePatientProfileParams({
    this.name,
    this.cityId,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (cityId != null) 'cityId': cityId,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
    };
  }
}
