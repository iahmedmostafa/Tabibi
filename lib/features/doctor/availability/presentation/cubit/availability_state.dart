import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/break_time.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/time_slot.dart';

class AvailabilityState extends Equatable {
  final Map<String, bool> workingDays;
  final List<TimeSlot> timeSlots;
  final List<BreakTime> breakTimes;
  final DateTime selectedDate;

  const AvailabilityState({
    this.workingDays = const {},
    this.timeSlots = const [],
    this.breakTimes = const [],
    required this.selectedDate,
  });

  AvailabilityState copyWith({
    Map<String, bool>? workingDays,
    List<TimeSlot>? timeSlots,
    List<BreakTime>? breakTimes,
    DateTime? selectedDate,
  }) {
    return AvailabilityState(
      workingDays: workingDays ?? this.workingDays,
      timeSlots: timeSlots ?? this.timeSlots,
      breakTimes: breakTimes ?? this.breakTimes,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [workingDays, timeSlots, breakTimes, selectedDate];
}
