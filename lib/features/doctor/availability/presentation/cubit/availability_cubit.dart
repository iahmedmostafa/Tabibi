import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/availability/data/models/update_schedule_params.dart';
import 'package:tabibi/features/doctor/availability/domain/usecases/get_availability_use_case.dart';
import 'package:tabibi/features/doctor/availability/domain/usecases/update_availability_use_case.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/time_slot.dart';
import 'availability_state.dart';

class AvailabilityCubit extends Cubit<AvailabilityState> {
  final GetAvailabilityUseCase _getAvailabilityUseCase;
  final UpdateAvailabilityUseCase _updateAvailabilityUseCase;

  AvailabilityCubit(
    this._getAvailabilityUseCase,
    this._updateAvailabilityUseCase,
  ) : super(
          AvailabilityState(
            selectedDate: DateTime.now(),
            isInitialLoading: true,
          ),
        );

  Future<void> getSchedule() async {
    emit(state.copyWith(
      status: AvailabilityStatus.loading,
      isInitialLoading: true,
      errorMessage: null,
    ));

    final result = await _getAvailabilityUseCase();

    result.fold(
      (_) {
        emit(state.copyWith(
          status: AvailabilityStatus.idle,
          isInitialLoading: false,
          workingDays: const {
            'Monday': true,
            'Tuesday': true,
            'Wednesday': true,
            'Thursday': true,
            'Friday': true,
            'Saturday': false,
            'Sunday': false,
          },
          timeSlots: [
            TimeSlot(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              day: 'Monday',
              startTime: TimeOfDay(hour: 9, minute: 0),
              endTime: TimeOfDay(hour: 17, minute: 0),
            ),
          ],
        ));
      },
      (schedule) {
        emit(state.copyWith(
          status: AvailabilityStatus.idle,
          isInitialLoading: false,
          workingDays: _buildWorkingDays(schedule),
          timeSlots: _buildTimeSlots(schedule),
        ));
      },
    );
  }

  void resetStatus() {
    emit(state.copyWith(
      status: AvailabilityStatus.idle,
      errorMessage: null,
    ));
  }

  // --- Working Days ---
  void toggleWorkingDay(String day, bool value) {
    final newWorkingDays = Map<String, bool>.from(state.workingDays);
    newWorkingDays[day] = value;
    emit(state.copyWith(workingDays: newWorkingDays));
  }

  // --- Time Slots ---
  void addTimeSlot(String day) {
    final newSlot = TimeSlot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      day: day,
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
    );
    emit(state.copyWith(timeSlots: [...state.timeSlots, newSlot]));
  }

  void updateTimeSlot(String id, {TimeOfDay? startTime, TimeOfDay? endTime}) {
    final newSlots = state.timeSlots.map((slot) {
      if (slot.id == id) {
        return slot.copyWith(startTime: startTime, endTime: endTime);
      }
      return slot;
    }).toList();
    emit(state.copyWith(timeSlots: newSlots));
  }

  void removeTimeSlot(String id) {
    final newSlots = state.timeSlots.where((slot) => slot.id != id).toList();
    emit(state.copyWith(timeSlots: newSlots));
  }

  // --- Calendar ---
  void changeMonth(int monthOffset) {
    final current = state.selectedDate;
    final newMonth = current.month + monthOffset;
    final newYear =
        current.year +
        (newMonth > 12
            ? 1
            : newMonth < 1
            ? -1
            : 0);
    final adjustedMonth = newMonth > 12
        ? 1
        : newMonth < 1
        ? 12
        : newMonth;

    final lastDayOfMonth = DateTime(newYear, adjustedMonth + 1, 0).day;
    final day = current.day > lastDayOfMonth ? lastDayOfMonth : current.day;

    emit(state.copyWith(selectedDate: DateTime(newYear, adjustedMonth, day)));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  // --- Save ---
  Future<void> save() async {
    emit(state.copyWith(
      status: AvailabilityStatus.loading,
      errorMessage: null,
    ));

    final params = _buildParams();
    final result = await _updateAvailabilityUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AvailabilityStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: AvailabilityStatus.success,
      )),
    );
  }

  UpdateScheduleParams _buildParams() {
    final schedule = <ScheduleDayParams>[];
    for (final entry in state.workingDays.entries) {
      if (!entry.value) continue;
      final daySlots =
          state.timeSlots.where((slot) => slot.day == entry.key).toList();
      for (final slot in daySlots) {
        schedule.add(
          ScheduleDayParams(
            dayOfWeek: _dayToInt(entry.key),
            openTime: _formatTime(slot.startTime),
            closeTime: _formatTime(slot.endTime),
          ),
        );
      }
    }
    return UpdateScheduleParams(schedule: schedule);
  }

  Map<String, bool> _buildWorkingDays(List<ScheduleDayParams> schedule) {
    final enabledDays = schedule.map((s) => _intToDay(s.dayOfWeek)).toSet();
    return {
      'Monday': enabledDays.contains('Monday'),
      'Tuesday': enabledDays.contains('Tuesday'),
      'Wednesday': enabledDays.contains('Wednesday'),
      'Thursday': enabledDays.contains('Thursday'),
      'Friday': enabledDays.contains('Friday'),
      'Saturday': enabledDays.contains('Saturday'),
      'Sunday': enabledDays.contains('Sunday'),
    };
  }

  List<TimeSlot> _buildTimeSlots(List<ScheduleDayParams> schedule) {
    final slots = <TimeSlot>[];
    var id = 1;
    for (final s in schedule) {
      final day = _intToDay(s.dayOfWeek);
      if (day.isEmpty) continue;
      final parts = s.openTime.split(':');
      final startHour = int.tryParse(parts[0]) ?? 9;
      final startMinute = int.tryParse(parts[1]) ?? 0;
      final endParts = s.closeTime.split(':');
      final endHour = int.tryParse(endParts[0]) ?? 17;
      final endMinute = int.tryParse(endParts[1]) ?? 0;
      slots.add(
        TimeSlot(
          id: (id++).toString(),
          day: day,
          startTime: TimeOfDay(hour: startHour, minute: startMinute),
          endTime: TimeOfDay(hour: endHour, minute: endMinute),
        ),
      );
    }
    return slots;
  }

  String _intToDay(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  int _dayToInt(String day) {
    switch (day) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        return 0;
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
