import 'package:equatable/equatable.dart';

class DoctorProfileEntity extends Equatable {
  final String name;
  final String email;
  final String? avatarUrl;
  final int gender;
  final DateTime? dateOfBirth;
  final String? bio;
  final String consultationFee;
  final String yearsOfExperience;
  final String? credentialImageUrl;
  final DateTime createdAtUtc;
  final DepartmentEntity? department;
  final ClinicEntity? clinic;
  final List<ScheduleEntity> schedule;

  const DoctorProfileEntity({
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.gender,
    this.dateOfBirth,
    this.bio,
    required this.consultationFee,
    required this.yearsOfExperience,
    this.credentialImageUrl,
    required this.createdAtUtc,
    this.department,
    this.clinic,
    required this.schedule,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        avatarUrl,
        gender,
        dateOfBirth,
        bio,
        consultationFee,
        yearsOfExperience,
        credentialImageUrl,
        createdAtUtc,
        department,
        clinic,
        schedule,
      ];
}

class DepartmentEntity extends Equatable {
  final String id;
  final String name;

  const DepartmentEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class ClinicEntity extends Equatable {
  final String name;
  final String? description;
  final String address;
  final String? imageUrl;
  final String phoneNumber;
  final CityEntity? city;

  const ClinicEntity({
    required this.name,
    this.description,
    required this.address,
    this.imageUrl,
    required this.phoneNumber,
    this.city,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        address,
        imageUrl,
        phoneNumber,
        city,
      ];
}

class CityEntity extends Equatable {
  final String id;
  final String name;

  const CityEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class ScheduleEntity extends Equatable {
  final int dayOfWeek;
  final String openTime;
  final String closeTime;

  const ScheduleEntity({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });

  @override
  List<Object?> get props => [dayOfWeek, openTime, closeTime];
}
