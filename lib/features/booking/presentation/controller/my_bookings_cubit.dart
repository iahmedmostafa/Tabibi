import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/booking/domain/entities/booking.dart';

part 'my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit() : super(MyBookingsState.initial());

  void getBookings({BookingStatus? status}) async {
    emit(state.copyWith(status: MyBookingsStatus.loading));

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock data
    List<Booking> mockBookings = [
      const Booking(
        id: '1',
        date: 'May 22, 2023',
        time: '10.00 AM',
        doctorName: 'Dr. James Robinson',
        doctorImage: 'https://i.pravatar.cc/150?u=a042581f4e29026024d',
        speciality: 'Orthopedic Surgery',
        location: 'Elite Ortho Clinic, USA',
        status: BookingStatus.upcoming,
      ),
      const Booking(
        id: '2',
        date: 'June 14, 2023',
        time: '15.00 PM',
        doctorName: 'Dr. Daniel Lee',
        doctorImage: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
        speciality: 'Gastroenterologist',
        location: 'Digestive Institute, USA',
        status: BookingStatus.upcoming,
      ),
      const Booking(
        id: '3',
        date: 'March 12, 2023',
        time: '11.00 AM',
        doctorName: 'Dr. Sarah Johnson',
        doctorImage: 'https://i.pravatar.cc/150?u=a042581f4e29026704e',
        speciality: 'Gynecologist',
        location: 'Women\'s Health Clinic',
        status: BookingStatus.completed,
      ),
      const Booking(
        id: '4',
        date: 'June 21, 2023',
        time: '10.00 AM',
        doctorName: 'Dr. Nathan Harris',
        doctorImage: 'https://i.pravatar.cc/150?u=a042581f4e29026704f',
        speciality: 'Dermatologist',
        location: 'Skin Care Center, USA',
        status: BookingStatus.canceled,
      ),
    ];

    emit(
      state.copyWith(
        status: MyBookingsStatus.success,
        allBookings: mockBookings,
      ),
    );

    filterBookings(status ?? BookingStatus.upcoming);
  }

  void filterBookings(BookingStatus status) {
    if (state.allBookings.isEmpty) return;

    final filtered = state.allBookings
        .where((booking) => booking.status == status)
        .toList();
    emit(state.copyWith(selectedTab: status, filteredBookings: filtered));
  }
}
