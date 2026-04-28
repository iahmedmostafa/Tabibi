import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/services/payment_manager.dart';
import 'package:tabibi/core/utils/backend_date_time.dart';
import 'package:tabibi/features/booking/domain/entities/available_slot.dart';
import 'package:tabibi/features/booking/domain/usecases/cancel_booking_use_case.dart';
import 'package:tabibi/features/booking/domain/usecases/confirm_payment_use_case.dart';
import 'package:tabibi/features/booking/domain/usecases/create_booking_use_case.dart';
import 'package:tabibi/features/booking/domain/usecases/get_available_slots_use_case.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final GetAvailableSlotsUseCase getAvailableSlotsUseCase;
  final CreateBookingUseCase createBookingUseCase;
  final ConfirmPaymentUseCase confirmPaymentUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  AppointmentCubit(
    this.getAvailableSlotsUseCase,
    this.createBookingUseCase,
    this.confirmPaymentUseCase,
    this.cancelBookingUseCase,
  ) : super(AppointmentInitial());

  DateTime? selectedDate;
  String? selectedTime;
  int selectedType = 0; // Default to Clinic
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
    if (selectedDate != null) {
      emit(AppointmentReadyToBook(selectedDate!, selectedTime!));
    }
  }

  void selectType(int type) {
    selectedType = type;
    emit(AppointmentTypeSelected(type));
    if (selectedDate != null && selectedTime != null) {
      emit(AppointmentReadyToBook(selectedDate!, selectedTime!));
    }
  }

  Future<void> bookAppointment({required String doctorId}) async {
    if (selectedDate == null || selectedTime == null) return;

    emit(AppointmentBookingLoading());
    try {
      final String appointmentDate;

      if (selectedTime!.contains('T')) {
        // Slot values returned by the backend already represent UTC instants.
        appointmentDate = BackendDateTime.parseUtc(
          selectedTime!,
        ).toIso8601String();
      } else {
        // Manual fallback for local time-only values.
        final localDateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          int.parse(selectedTime!.split(':')[0]),
          int.parse(selectedTime!.split(':')[1]),
        );
        final utcDateTime = localDateTime.toUtc();
        appointmentDate = utcDateTime.toIso8601String();
      }
      log("Sending appointment in UTC: $appointmentDate");
      final result = await createBookingUseCase.execute(
        appointmentDate: appointmentDate,
        doctorId: doctorId,
        type: selectedType,
      );

      await result.fold(
        (failure) async {
          log(failure.message);
          emit(AppointmentFailure(failure.message));
        },
        (data) async {
          final clientSecret = data[ApiKeys.clientSecret];
          final bookingId = data[ApiKeys.bookingId];
          log("clientSecret: ${clientSecret.toString()}");
          log("bookingId: ${bookingId.toString()}");

          if (clientSecret == null || bookingId == null) {
            const error = "Failed to initiate payment process";
            emit(const AppointmentFailure(error));
            return;
          }

          // 2. Process Stripe payment
          try {
            await PaymentManager.makePayment(clientSecret: clientSecret);

            // 3. Confirm payment to backend
            final confirmResult = await confirmPaymentUseCase.execute(
              bookingId: bookingId,
            );

            confirmResult.fold(
              (failure) {
                emit(AppointmentFailure(failure.message));
              },
              (_) {
                emit(AppointmentBookingSuccess());
              },
            );
          } catch (e) {
            final errorMsg = "Payment failed or cancelled: ${e.toString()}";
            emit(AppointmentFailure(errorMsg));

            // Optionally call cancel booking if payment failed
            await cancelBooking(bookingId: bookingId);
          }
        },
      );
    } catch (e) {
      final errorMsg = "An error occurred: ${e.toString()}";

      emit(AppointmentFailure(errorMsg));
    }
  }

  Future<void> cancelBooking({required String bookingId}) async {
    emit(AppointmentBookingLoading());
    final result = await cancelBookingUseCase.execute(bookingId: bookingId);

    result.fold(
      (failure) {
        emit(AppointmentFailure(failure.message));
      },
      (_) {
        log("Booking cancelled successfully");
      },
    );
  }
}
