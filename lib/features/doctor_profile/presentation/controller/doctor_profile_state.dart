import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor_profile/data/models/doctor_profile_model.dart';

enum DoctorProfileStatus { initial, loading, success, failure }

enum DoctorProfileUpdateStatus { initial, loading, success, failure }

enum DoctorStatusAction { initial, loading, success, failure }

class DoctorProfileState {
  final DoctorProfileStatus status;
  final DoctorProfileUpdateStatus updateStatus;
  final DoctorProfileModel? profile;
  final String updateMessage;
  final String? errorMessage;
  final DoctorStatusAction? doctorStatus;
  final DoctorStatus? newDoctorStatus;

  const DoctorProfileState({
    this.status = DoctorProfileStatus.initial,
    this.updateStatus = DoctorProfileUpdateStatus.initial,
    this.profile,
    this.newDoctorStatus,
    this.doctorStatus,
    this.errorMessage,
    this.updateMessage = '',
  });

  DoctorProfileState copyWith({
    DoctorProfileStatus? status,
    DoctorProfileUpdateStatus? updateStatus,
    DoctorProfileModel? profile,
    DoctorStatus? newDoctorStatus,
    DoctorStatusAction? doctorStatus,
    String? errorMessage,
    String? updateMessage,
  }) {
    return DoctorProfileState(
      status: status ?? this.status,
      updateStatus: updateStatus ?? this.updateStatus,
      profile: profile ?? this.profile,
      newDoctorStatus: newDoctorStatus ?? this.newDoctorStatus,
      doctorStatus: doctorStatus ?? this.doctorStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      updateMessage: updateMessage ?? this.updateMessage,
    );
  }
}
