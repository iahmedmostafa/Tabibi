import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

class DoctorDetailsModel extends DoctorDetails {
  const DoctorDetailsModel({
    required super.id,
    required super.name,
    super.avatarUrl,
    required super.department,
    required super.address,
    super.bio,
    required super.yearsOfExperience,
    required super.consultationFee,
    required super.rating,
    required super.reviewCount,
    required super.patientCount,
    required List<ReviewModel> super.reviews,
    required List<ScheduleModel> super.schedule,
  });

  factory DoctorDetailsModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      department: json['department'],
      address: json['address'],
      bio: json['bio'],
      yearsOfExperience: json['yearsOfExperience'],
      consultationFee: (json['consultationFee'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'],
      patientCount: json['patientCount'],
      reviews: (json['reviews'] as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
      schedule: (json['schedule'] as List)
          .map((e) => ScheduleModel.fromJson(e))
          .toList(),
    );
  }
}

class ReviewModel extends DoctorReview {
  const ReviewModel({
    required super.id,
    required super.rating,
    super.comment,
    required super.createdAt,
    required super.patientName,
    super.patientAvatar,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    String dateStr = json['createdAt'] as String;
    if (!dateStr.endsWith('Z')) dateStr += 'Z';
    return ReviewModel(
      id: json['id'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(dateStr).toLocal(),
      patientName: json['patientName'],
      patientAvatar: json['patientAvatar'],
    );
  }
}

class ScheduleModel extends DoctorSchedule {
  const ScheduleModel({
    required super.dayOfWeek,
    required super.openTime,
    required super.closeTime,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      dayOfWeek: json['dayOfWeek'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
    );
  }
}
