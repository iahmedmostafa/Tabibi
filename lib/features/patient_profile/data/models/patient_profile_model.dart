import 'package:tabibi/features/patient_profile/domain/entities/patient_profile.dart';

class PatientProfileModel extends PatientProfile {
  const PatientProfileModel({
    required super.name,
    required super.email,
    super.avatarUrl,
    super.gender,
    super.dateOfBirth,
    required super.createdAtUtc,
    super.updatedAtUtc,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      gender: json['gender'] as int?,
      dateOfBirth: json['dateOfBirth'] as String?,
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
      'createdAtUtc': createdAtUtc,
      'updatedAtUtc': updatedAtUtc,
    };
  }
}
