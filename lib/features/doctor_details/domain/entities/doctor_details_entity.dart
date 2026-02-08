import 'package:equatable/equatable.dart';

class DoctorDetails extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final String department;
  final String address;
  final String? bio;
  final int yearsOfExperience;
  final double consultationFee;
  final double rating;
  final int reviewCount;
  final int patientCount;
  final List<DoctorReview> reviews;
  final List<DoctorSchedule> schedule;

  const DoctorDetails({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.department,
    required this.address,
    this.bio,
    required this.yearsOfExperience,
    required this.consultationFee,
    required this.rating,
    required this.reviewCount,
    required this.patientCount,
    required this.reviews,
    required this.schedule,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    avatarUrl,
    department,
    address,
    bio,
    yearsOfExperience,
    consultationFee,
    rating,
    reviewCount,
    patientCount,
    reviews,
    schedule,
  ];
}

class DoctorReview extends Equatable {
  final String id;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final String patientName;
  final String? patientAvatar;

  const DoctorReview({
    required this.id,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.patientName,
    this.patientAvatar,
  });

  @override
  List<Object?> get props => [
    id,
    rating,
    comment,
    createdAt,
    patientName,
    patientAvatar,
  ];
}

class DoctorSchedule extends Equatable {
  final int dayOfWeek;
  final String openTime;
  final String closeTime;

  const DoctorSchedule({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });

  @override
  List<Object?> get props => [dayOfWeek, openTime, closeTime];
}
