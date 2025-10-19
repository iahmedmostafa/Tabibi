import 'package:equatable/equatable.dart';
import 'package:tabibi/core/utils/enums/enums.dart';

class SignUpState extends Equatable {
  final SignUpStatus status;
  final String? message;
  final String? errorMessage;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.message,
    this.errorMessage,
  });

  SignUpState copyWith({
    SignUpStatus? status,
    String? message,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, message, errorMessage];
}


