import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';

enum MedicalProfileStatus { initial, loading, success, failure }

enum MedicalProfileUpdateStatus { initial, loading, success, failure }

class MedicalProfileState {
  final MedicalProfileStatus status;
  final MedicalProfileUpdateStatus updateStatus;
  final MedicalProfileModel? profile;
  final String updateMessage;
  final String? errorMessage;

  const MedicalProfileState({
    this.status = MedicalProfileStatus.initial,
    this.updateStatus = MedicalProfileUpdateStatus.initial,
    this.profile,
    this.errorMessage,
    this.updateMessage = '',
  });

  MedicalProfileState copyWith({
    MedicalProfileStatus? status,
    MedicalProfileUpdateStatus? updateStatus,
    MedicalProfileModel? profile,
    String? errorMessage,
    String? updateMessage,
  }) {
    return MedicalProfileState(
      status: status ?? this.status,
      updateStatus: updateStatus ?? this.updateStatus,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      updateMessage: updateMessage ?? this.updateMessage,
    );
  }
}
