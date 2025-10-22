part of 'log_in_cubit.dart';

@immutable
sealed class LogInState {}

final class LogInInitial extends LogInState {}

final class LogInLoading extends LogInState {}

final class LogInSuccess extends LogInState {
  final LogInEntity logInEntity;
   LogInSuccess({required this.logInEntity,});
}

final class LogInFailure extends LogInState {
  final String errorMessage;
  LogInFailure({required this.errorMessage});
}