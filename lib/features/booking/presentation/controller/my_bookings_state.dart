part of 'my_bookings_cubit.dart';

enum MyBookingsStatus { initial, loading, success, failure }

class MyBookingsState extends Equatable {
  final MyBookingsStatus status;
  final List<BookingModel> allBookings;
  final BookingStatus selectedTab;
  final String? errorMessage;

  const MyBookingsState({
    this.status = MyBookingsStatus.initial,
    this.allBookings = const [],
    this.selectedTab = BookingStatus.upcoming,
    this.errorMessage,
  });


  MyBookingsState copyWith({
    MyBookingsStatus? status,
    List<BookingModel>? allBookings,
    BookingStatus? selectedTab,
    String? errorMessage,
  }) {
    return MyBookingsState(
      status: status ?? this.status,
      allBookings: allBookings ?? this.allBookings,
      selectedTab: selectedTab ?? this.selectedTab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, allBookings, selectedTab, errorMessage];
}
