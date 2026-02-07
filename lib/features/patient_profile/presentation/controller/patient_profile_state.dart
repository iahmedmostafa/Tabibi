import 'package:tabibi/features/patient_profile/data/models/patient_profile_model.dart';

enum PatientProfileStatus { initial, loading, success, failure }

enum PatientProfileUpdateStatus { initial, loading, success, failure }

class PatientProfileState {
  final PatientProfileStatus status;
  final PatientProfileUpdateStatus updateStatus;
  final PatientProfileModel? profile;
  final String updateMessage;
  final String? errorMessage;

  const PatientProfileState({
    this.status = PatientProfileStatus.initial,
    this.updateStatus = PatientProfileUpdateStatus.initial,
    this.profile,
    this.errorMessage,
    this.updateMessage = '',
  });

  PatientProfileState copyWith({
    PatientProfileStatus? status,
    PatientProfileUpdateStatus? updateStatus,
    PatientProfileModel? profile,
    String? errorMessage,
    String? updateMessage,
  }) {
    return PatientProfileState(
      status: status ?? this.status,
      updateStatus: updateStatus ?? this.updateStatus,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      updateMessage: updateMessage ?? this.updateMessage,
    );
  }
}
