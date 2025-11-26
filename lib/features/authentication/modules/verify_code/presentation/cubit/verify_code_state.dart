import 'package:equatable/equatable.dart';

enum VerifyCodeStatus { initial, loading, success, failure }

enum ResendCodeStatus { initial, loading, success, failure }

enum VerifyOrigin { unknown, signup, forgot }

class VerifyCodeState extends Equatable {
  final VerifyCodeStatus status;
  final ResendCodeStatus resendStatus;
  final String? message;
  final String? errorMessage;
  final String targetEmail;
  final VerifyOrigin origin;

  const VerifyCodeState({
    this.status = VerifyCodeStatus.initial,
    this.resendStatus = ResendCodeStatus.initial,
    this.message,
    this.errorMessage,
    this.targetEmail = '',
    this.origin = VerifyOrigin.unknown,
  });

  VerifyCodeState copyWith({
    VerifyCodeStatus? status,
    ResendCodeStatus? resendStatus,
    String? message,
    String? errorMessage,
    String? targetEmail,
    VerifyOrigin? origin,
  }) {
    return VerifyCodeState(
      status: status ?? this.status,
      resendStatus: resendStatus ?? this.resendStatus,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      targetEmail: targetEmail ?? this.targetEmail,
      origin: origin ?? this.origin,
    );
  }

  @override
  List<Object?> get props => [
    status,
    resendStatus,
    message,
    errorMessage,
    targetEmail,
    origin,
  ];
}
