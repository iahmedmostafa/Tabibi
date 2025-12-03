import 'package:tabibi/features/home/data/models/doctor_profile_model.dart';

enum DoctorProfileStatus { initial, loading, success, failure }

enum DoctorProfileUpdateStatus { initial, loading, success, failure }

class DoctorProfileState {
  final DoctorProfileStatus status;
  final DoctorProfileUpdateStatus updateStatus;
  final DoctorProfileModel? profile;
  final String updateMessage;
  final String? errorMessage;

  const DoctorProfileState({
    this.status = DoctorProfileStatus.initial,
    this.updateStatus = DoctorProfileUpdateStatus.initial,
    this.profile,
    this.errorMessage,
    this.updateMessage = '',
  });

  DoctorProfileState copyWith({
    DoctorProfileStatus? status,
    DoctorProfileUpdateStatus? updateStatus,
    DoctorProfileModel? profile,
    String? errorMessage,
    String? updateMessage,
  }) {
    return DoctorProfileState(
      status: status ?? this.status,
      updateStatus: updateStatus ?? this.updateStatus,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      updateMessage: updateMessage ?? this.updateMessage,
    );
  }
}
