import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentInitial());

  DateTime? selectedDate;
  String? selectedTime;

  void selectDate(DateTime date) {
    selectedDate = date;
    emit(AppointmentDateSelected(date));
    _checkBookingStatus();
  }

  void selectTime(String time) {
    selectedTime = time;
    emit(AppointmentTimeSelected(time));
    _checkBookingStatus();
  }

  void _checkBookingStatus() {
    if (selectedDate != null && selectedTime != null) {
      emit(AppointmentReadyToBook(selectedDate!, selectedTime!));
    }
  }

  Future<void> bookAppointment() async {
    emit(AppointmentBookingLoading());
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 2));
      emit(AppointmentBookingSuccess());
    } catch (e) {
      emit(const AppointmentFailure("Failed to book appointment"));
    }
  }
}
