import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/break_time.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/time_slot.dart';
import 'availability_state.dart';

class AvailabilityCubit extends Cubit<AvailabilityState> {
  AvailabilityCubit()
    : super(
        AvailabilityState(
          selectedDate: DateTime.now(),
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
              id: '1',
              day: 'Monday',
              startTime: const TimeOfDay(hour: 9, minute: 0),
              endTime: const TimeOfDay(hour: 17, minute: 0),
            ),
            // Add more mock data as needed
          ],
          breakTimes: [
            BreakTime(
              id: '1',
              startTime: const TimeOfDay(hour: 12, minute: 0),
              endTime: const TimeOfDay(hour: 13, minute: 0),
              label: 'Lunch Break',
            ),
          ],
        ),
      );

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

  // --- Break Times ---
  void addBreakTime() {
    final newBreak = BreakTime(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: const TimeOfDay(hour: 12, minute: 0),
      endTime: const TimeOfDay(hour: 13, minute: 0),
      label: 'Break',
    );
    emit(state.copyWith(breakTimes: [...state.breakTimes, newBreak]));
  }

  void updateBreakTime(
    String id, {
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? label,
  }) {
    final newBreaks = state.breakTimes.map((b) {
      if (b.id == id) {
        return b.copyWith(startTime: startTime, endTime: endTime, label: label);
      }
      return b;
    }).toList();
    emit(state.copyWith(breakTimes: newBreaks));
  }

  void removeBreakTime(String id) {
    final newBreaks = state.breakTimes.where((b) => b.id != id).toList();
    emit(state.copyWith(breakTimes: newBreaks));
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
}
