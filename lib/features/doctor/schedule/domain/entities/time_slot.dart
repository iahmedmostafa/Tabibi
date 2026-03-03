import 'package:flutter/material.dart';

class TimeSlot {
  final String id;
  final String day;
  TimeOfDay startTime;
  TimeOfDay endTime;

  TimeSlot({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  String get startTimeString {
    final hour = startTime.hourOfPeriod == 0 ? 12 : startTime.hourOfPeriod;
    final period = startTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} $period';
  }

  String get endTimeString {
    final hour = endTime.hourOfPeriod == 0 ? 12 : endTime.hourOfPeriod;
    final period = endTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')} $period';
  }

  TimeSlot copyWith({
    String? id,
    String? day,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
