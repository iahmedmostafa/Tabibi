part of 'appointment_cubit.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentDateSelected extends AppointmentState {
  final DateTime date;
  const AppointmentDateSelected(this.date);
  @override
  List<Object> get props => [date];
}

class AppointmentTimeSelected extends AppointmentState {
  final String time;
  const AppointmentTimeSelected(this.time);
  @override
  List<Object> get props => [time];
}

class AppointmentReadyToBook extends AppointmentState {
  final DateTime date;
  final String time;
  const AppointmentReadyToBook(this.date, this.time);
  @override
  List<Object> get props => [date, time];
}

class AppointmentBookingLoading extends AppointmentState {}

class AppointmentBookingSuccess extends AppointmentState {}

class AppointmentFailure extends AppointmentState {
  final String message;
  const AppointmentFailure(this.message);
  @override
  List<Object> get props => [message];
}
