import 'package:tabibi/features/home/data/models/patient_profile_model.dart';

enum PatientProfileStatus { initial, loading, success, failure }

class PatientProfileState {
  final PatientProfileStatus status;
  final PatientProfileModel? profile;
  final String? errorMessage;

  const PatientProfileState({
    this.status = PatientProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  PatientProfileState copyWith({
    PatientProfileStatus? status,
    PatientProfileModel? profile,
    String? errorMessage,
  }) {
    return PatientProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
