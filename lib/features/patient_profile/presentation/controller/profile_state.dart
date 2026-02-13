import 'package:equatable/equatable.dart';
import 'package:tabibi/features/patient_profile/domain/entities/patient_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final PatientProfile patientProfile;
  const ProfileLoaded(this.patientProfile);

  @override
  List<Object?> get props => [patientProfile];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class LogOutLoading extends ProfileState {}

class LogOutSuccess extends ProfileState {}

class LogOutError extends ProfileState {
  final String message;
  const LogOutError(this.message);
  @override
  List<Object?> get props => [message];
}
