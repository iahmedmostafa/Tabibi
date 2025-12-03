import 'package:tabibi/features/home/domain/entities/doctor_profile.dart';

class ScheduleModel extends Schedule {
  const ScheduleModel({
    required super.dayOfWeek,
    required super.openTime,
    required super.closeTime,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      dayOfWeek: json['dayOfWeek'] as int,
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}
