import 'package:equatable/equatable.dart';

abstract class DoctorLogoutState extends Equatable {
  const DoctorLogoutState();

  @override
  List<Object?> get props => [];
}

class DoctorLogoutInitial extends DoctorLogoutState {}

class DoctorLogoutLoading extends DoctorLogoutState {}

class DoctorLogoutSuccess extends DoctorLogoutState {}

class DoctorLogoutError extends DoctorLogoutState {
  final String message;

  const DoctorLogoutError(this.message);

  @override
  List<Object?> get props => [message];
}
