import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile_entity.dart';
import 'package:tabibi/core/utils/backend_date_time.dart';

class DoctorProfileModel extends DoctorProfileEntity {
  const DoctorProfileModel({
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.gender,
    super.dateOfBirth,
    super.bio,
    required super.consultationFee,
    required super.yearsOfExperience,
    super.credentialImageUrl,
    required super.createdAtUtc,
    super.department,
    super.clinic,
    required super.schedule,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      gender: json['gender'] ?? 1,
      dateOfBirth: json['dateOfBirth'] != null ? BackendDateTime.tryParseUtc(json['dateOfBirth']) : null,
      bio: json['bio'],
      consultationFee: json['consultationFee']?.toString() ?? '0',
      yearsOfExperience: json['yearsOfExperience']?.toString() ?? '0',
      credentialImageUrl: json['credentialImageUrl'],
      createdAtUtc: json['createdAtUtc'] != null 
          ? BackendDateTime.tryParseUtc(json['createdAtUtc']) ?? DateTime.now().toUtc() 
          : DateTime.now().toUtc(),
      department: json['department'] != null ? DepartmentModel.fromJson(json['department']) : null,
      clinic: json['clinic'] != null ? ClinicModel.fromJson(json['clinic']) : null,
      schedule: (json['schedule'] as List?)?.map((e) => ScheduleModel.fromJson(e)).toList() ?? [],
    );
  }
}

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({required super.id, required super.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ClinicModel extends ClinicEntity {
  const ClinicModel({
    required super.name,
    super.description,
    required super.address,
    super.imageUrl,
    required super.phoneNumber,
    super.city,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      name: json['name'] ?? '',
      description: json['description'],
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'],
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] != null ? CityModel.fromJson(json['city']) : null,
    );
  }
}

class CityModel extends CityEntity {
  const CityModel({required super.id, required super.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({
    required super.dayOfWeek,
    required super.openTime,
    required super.closeTime,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      dayOfWeek: json['dayOfWeek'] ?? 1,
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
    );
  }
}
