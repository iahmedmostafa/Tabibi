import 'package:equatable/equatable.dart';

enum CreatePrescriptionStatus {
  initial,
  loading,
  success,
  failure,
  completionFailure,
}

class CreatePrescriptionState extends Equatable {
  final CreatePrescriptionStatus status;
  final String? errorMessage;

  const CreatePrescriptionState({
    this.status = CreatePrescriptionStatus.initial,
    this.errorMessage,
  });

  CreatePrescriptionState copyWith({
    CreatePrescriptionStatus? status,
    String? errorMessage,
  }) {
    return CreatePrescriptionState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
