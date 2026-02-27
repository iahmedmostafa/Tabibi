import 'package:tabibi/features/patient_profile/domain/entities/patient_profile.dart';

class PatientProfileModel extends PatientProfile {
  const PatientProfileModel({
    required super.name,
    required super.email,
    super.avatarUrl,
    super.gender,
    super.dateOfBirth,
    super.city,
    required super.createdAtUtc,
    super.updatedAtUtc,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    PatientProfileCity? city;
    if (json['city'] != null && json['city'] is Map<String, dynamic>) {
      final cityMap = json['city'] as Map<String, dynamic>;
      city = PatientProfileCity(
        id: cityMap['id'] as String? ?? '',
        name: cityMap['name'] as String? ?? '',
      );
    }

    return PatientProfileModel(
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      gender: json['gender'] as int?,
      dateOfBirth: json['dateOfBirth'] as String?,
      city: city,
      createdAtUtc: json['createdAtUtc'] as String,
      updatedAtUtc: json['updatedAtUtc'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'city': city != null ? {'id': city!.id, 'name': city!.name} : null,
      'createdAtUtc': createdAtUtc,
      'updatedAtUtc': updatedAtUtc,
    };
  }
}
