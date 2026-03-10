import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/schedule_appointment.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleAppointment> appointments;

  const ScheduleLoaded({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError({required this.message});

  @override
  List<Object?> get props => [message];
}
