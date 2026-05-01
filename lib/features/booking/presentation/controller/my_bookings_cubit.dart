import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/helper/backend_date_time.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/booking/data/models/booking_model.dart';
import 'package:tabibi/features/booking/domain/usecases/get_my_bookings.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';

part 'my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final GetMyBookingsUseCase getMyBookingsUseCase;
  MyBookingsCubit(this.getMyBookingsUseCase) : super(const MyBookingsState());

  void getBookings({BookingStatus status = BookingStatus.upcoming}) async {
    emit(state.copyWith(status: MyBookingsStatus.loading));
    final result = await getMyBookingsUseCase.getMyBookings(
      _bookingStatusValue(status),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MyBookingsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (bookings) {
        List<BookingModel> filteredBookings = bookings;
        if (status == BookingStatus.upcoming) {
          final nowUtc = DateTime.now().toUtc();
          final todayUtc = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
          filteredBookings = bookings.where((booking) {
            try {
              final appointmentDate = BackendDateTime.parseUtc(
                booking.appointmentDate,
              );
              return !appointmentDate.isBefore(todayUtc);
            } catch (e) {
              return true;
            }
          }).toList();
        }

        emit(
          state.copyWith(
            status: MyBookingsStatus.success,
            allBookings: filteredBookings,
            selectedTab: status,
          ),
        );
      },
    );
  }

  int _bookingStatusValue(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return DoctorAppointmentStatus.upcoming;
      case BookingStatus.completed:
        return DoctorAppointmentStatus.completed;
      case BookingStatus.cancelled:
        return DoctorAppointmentStatus.refunded;
    }
  }
}
