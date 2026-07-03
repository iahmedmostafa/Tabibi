class UpdateScheduleParams {
  final List<ScheduleDayParams> schedule;

  const UpdateScheduleParams({required this.schedule});

  Map<String, dynamic> toJson() {
    return {
      'schedule': schedule.map((s) => s.toJson()).toList(),
    };
  }
}

class ScheduleDayParams {
  final int dayOfWeek;
  final String openTime;
  final String closeTime;

  const ScheduleDayParams({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });

  factory ScheduleDayParams.fromJson(Map<String, dynamic> json) {
    return ScheduleDayParams(
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
