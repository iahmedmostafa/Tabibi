part of 'prescription_cubit.dart';

enum PrescriptionStatus { initial, loading, success, failure }

class PrescriptionState extends Equatable {
  final PrescriptionStatus status;
  final PrescriptionModel? prescription;
  final String? errorMessage;

  const PrescriptionState({
    this.status = PrescriptionStatus.initial,
    this.prescription,
    this.errorMessage,
  });

  PrescriptionState copyWith({
    PrescriptionStatus? status,
    PrescriptionModel? prescription,
    String? errorMessage,
  }) {
    return PrescriptionState(
      status: status ?? this.status,
      prescription: prescription ?? this.prescription,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, prescription, errorMessage];
}
