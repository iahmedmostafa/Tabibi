import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/time_slot.dart';

enum AvailabilityStatus { idle, loading, success, error }

class AvailabilityState extends Equatable {
  final AvailabilityStatus status;
  final String? errorMessage;
  final bool isInitialLoading;
  final Map<String, bool> workingDays;
  final List<TimeSlot> timeSlots;
  final DateTime selectedDate;

  const AvailabilityState({
    this.status = AvailabilityStatus.idle,
    this.errorMessage,
    this.isInitialLoading = false,
    this.workingDays = const {},
    this.timeSlots = const [],
    required this.selectedDate,
  });

  AvailabilityState copyWith({
    AvailabilityStatus? status,
    String? errorMessage,
    bool? isInitialLoading,
    Map<String, bool>? workingDays,
    List<TimeSlot>? timeSlots,
    DateTime? selectedDate,
  }) {
    return AvailabilityState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      workingDays: workingDays ?? this.workingDays,
      timeSlots: timeSlots ?? this.timeSlots,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isInitialLoading,
        workingDays,
        timeSlots,
        selectedDate,
      ];
}
