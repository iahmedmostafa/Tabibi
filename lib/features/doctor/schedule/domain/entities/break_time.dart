import 'package:flutter/material.dart';

class BreakTime {
  final String id;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String label;

  BreakTime({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.label,
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

  BreakTime copyWith({
    String? id,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? label,
  }) {
    return BreakTime(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      label: label ?? this.label,
    );
  }
}
