class WorkScheduleDto {
  final int dayOfWeek;
  final String openTime;
  final String closeTime;

  WorkScheduleDto({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}
