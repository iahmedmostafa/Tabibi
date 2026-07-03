import 'package:equatable/equatable.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';

enum MedicalHistoryStatus { initial, loading, success, error }

class MedicalHistoryState extends Equatable {
  final MedicalHistoryStatus status;
  final MedicalProfileModel? profile;
  final String? errorMessage;

  const MedicalHistoryState({
    this.status = MedicalHistoryStatus.initial,
    this.profile,
    this.errorMessage,
  });

  MedicalHistoryState copyWith({
    MedicalHistoryStatus? status,
    MedicalProfileModel? profile,
    String? errorMessage,
  }) {
    return MedicalHistoryState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
