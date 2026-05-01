import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/booking/data/models/upcoming_booking_summary_model.dart';
import 'package:tabibi/features/booking/domain/usecases/get_next_upcoming_booking_use_case.dart';

part 'upcoming_booking_state.dart';

class UpcomingBookingCubit extends Cubit<UpcomingBookingState> {
  UpcomingBookingCubit(this._getNextUpcomingBookingUseCase)
    : super(const UpcomingBookingState());

  final GetNextUpcomingBookingUseCase _getNextUpcomingBookingUseCase;

  Future<void> loadUpcomingBooking() async {
    emit(state.copyWith(status: UpcomingBookingStatus.loading));

    final result = await _getNextUpcomingBookingUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UpcomingBookingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (summary) => emit(
        state.copyWith(status: UpcomingBookingStatus.success, summary: summary),
      ),
    );
  }
}
