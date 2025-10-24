import 'package:equatable/equatable.dart';

enum CreatePasswordStatus { initial, loading, success, failure }

class CreateNewPasswordState extends Equatable {
  final CreatePasswordStatus status;
  final String? message;
  final String? errorMessage;
  final String targetEmail;

  const CreateNewPasswordState({
    this.status = CreatePasswordStatus.initial,
    this.message,
    this.errorMessage,
    this.targetEmail = '',
  });

  CreateNewPasswordState copyWith({
    CreatePasswordStatus? status,
    String? message,
    String? errorMessage,
    String? targetEmail,
  }) {
    return CreateNewPasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      targetEmail: targetEmail ?? this.targetEmail,
    );
  }

  @override
  List<Object?> get props => [status, message, errorMessage, targetEmail];
}