part of 'my_bookings_cubit.dart';

enum MyBookingsStatus { initial, loading, success, failure }

class MyBookingsState extends Equatable {
  final MyBookingsStatus status;
  final List<Booking> allBookings;
  final List<Booking> filteredBookings;
  final BookingStatus selectedTab;
  final String? errorMessage;

  const MyBookingsState({
    required this.status,
    required this.allBookings,
    required this.filteredBookings,
    required this.selectedTab,
    this.errorMessage,
  });

  factory MyBookingsState.initial() {
    return const MyBookingsState(
      status: MyBookingsStatus.initial,
      allBookings: [],
      filteredBookings: [],
      selectedTab: BookingStatus.upcoming,
    );
  }

  MyBookingsState copyWith({
    MyBookingsStatus? status,
    List<Booking>? allBookings,
    List<Booking>? filteredBookings,
    BookingStatus? selectedTab,
    String? errorMessage,
  }) {
    return MyBookingsState(
      status: status ?? this.status,
      allBookings: allBookings ?? this.allBookings,
      filteredBookings: filteredBookings ?? this.filteredBookings,
      selectedTab: selectedTab ?? this.selectedTab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allBookings,
    filteredBookings,
    selectedTab,
    errorMessage,
  ];
}
