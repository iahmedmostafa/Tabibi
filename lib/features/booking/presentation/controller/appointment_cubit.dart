import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/features/booking/domain/entities/available_slot.dart';
import 'package:tabibi/features/booking/domain/usecases/get_available_slots_use_case.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final GetAvailableSlotsUseCase getAvailableSlotsUseCase;

  AppointmentCubit(this.getAvailableSlotsUseCase) : super(AppointmentInitial());

  DateTime? selectedDate;
  String? selectedTime;
  List<AvailableSlot> availableSlots = [];

  void selectDate(DateTime date, {required String doctorId}) {
    selectedDate = date;
    selectedTime = null; // Reset time when date changes
    emit(AppointmentDateSelected(date));
    getAvailableSlots(doctorId: doctorId, date: date);
  }

  Future<void> getAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    emit(AppointmentSlotsLoading());
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final result = await getAvailableSlotsUseCase.execute(
      doctorId: doctorId,
      date: formattedDate,
    );

    result.fold((failure) => emit(AppointmentSlotsFailure(failure.message)), (
      slots,
    ) {
      availableSlots = slots;
      emit(AppointmentSlotsSuccess(slots));
    });
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
