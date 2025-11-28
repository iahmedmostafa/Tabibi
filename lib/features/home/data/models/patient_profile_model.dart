import 'package:tabibi/features/home/domain/entities/patient_profile.dart';

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
    return PatientProfileModel(
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      city: json['city'] as String?,
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
      'city': city,
      'createdAtUtc': createdAtUtc,
      'updatedAtUtc': updatedAtUtc,
    };
  }
}
