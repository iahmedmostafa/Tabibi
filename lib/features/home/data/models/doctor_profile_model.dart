import 'package:tabibi/features/home/data/models/sub_models/clinic_model.dart';
import 'package:tabibi/features/home/data/models/sub_models/schedule_model.dart';
import 'package:tabibi/features/home/domain/entities/doctor_profile.dart';

class DoctorProfileModel extends DoctorProfile {
  const DoctorProfileModel({
    required super.name,
    super.avatarUrl,
    required super.gender,
    super.dateOfBirth,
    super.bio,
    required super.consultationFee,
    required super.credentialImageUrl,
    required super.yearsOfExperience,
    required super.departmentId,
    required super.clinic,
    required super.schedule,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      gender: json['gender'] as int,
      dateOfBirth: json['dateOfBirth'] as String?,
      bio: json['bio'] as String?,
      consultationFee: (json['consultationFee'] as num).toDouble(),
      credentialImageUrl: json['credentialImageUrl'] as String,
      yearsOfExperience: json['yearsOfExperience'] as int,
      departmentId: json['departmentId'] as String,
      clinic: ClinicModel.fromJson(json['clinic']),
      schedule: (json['schedule'] as List<dynamic>)
          .map((e) => ScheduleModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'bio': bio,
      'consultationFee': consultationFee,
      'credentialImageUrl': credentialImageUrl,
      'yearsOfExperience': yearsOfExperience,
      'departmentId': departmentId,
      'clinic': (clinic as ClinicModel).toJson(),
      'schedule': schedule.map((s) => (s as ScheduleModel).toJson()).toList(),
    };
  }
}
