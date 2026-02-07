import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  // Add user entity here if needed to display user info
  const ProfileLoaded();
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
