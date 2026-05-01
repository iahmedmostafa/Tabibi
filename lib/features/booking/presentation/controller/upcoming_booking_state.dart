part of 'upcoming_booking_cubit.dart';

enum UpcomingBookingStatus { initial, loading, success, failure }

class UpcomingBookingState {
  final UpcomingBookingStatus status;
  final UpcomingBookingSummaryModel? summary;
  final String? errorMessage;

  const UpcomingBookingState({
    this.status = UpcomingBookingStatus.initial,
    this.summary,
    this.errorMessage,
  });

  UpcomingBookingState copyWith({
    UpcomingBookingStatus? status,
    UpcomingBookingSummaryModel? summary,
    String? errorMessage,
  }) {
    return UpcomingBookingState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
