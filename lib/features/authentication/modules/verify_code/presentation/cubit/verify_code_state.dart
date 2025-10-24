import 'package:equatable/equatable.dart';

enum VerifyCodeStatus { initial, loading, success, failure }
enum ResendCodeStatus { initial, loading, success, failure }

class VerifyCodeState extends Equatable {
  final VerifyCodeStatus status;
  final ResendCodeStatus resendStatus;
  final String? message;
  final String? errorMessage;
  final String targetEmail;

  const VerifyCodeState({
    this.status = VerifyCodeStatus.initial,
    this.resendStatus = ResendCodeStatus.initial,
    this.message,
    this.errorMessage,
    this.targetEmail = '',
  });

  VerifyCodeState copyWith({
    VerifyCodeStatus? status,
    ResendCodeStatus? resendStatus,
    String? message,
    String? errorMessage,
    String? targetEmail,
  }) {
    return VerifyCodeState(
      status: status ?? this.status,
      resendStatus: resendStatus ?? this.resendStatus,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      targetEmail: targetEmail ?? this.targetEmail,
    );
  }

  @override
  List<Object?> get props => [status, resendStatus, message, errorMessage, targetEmail];
}