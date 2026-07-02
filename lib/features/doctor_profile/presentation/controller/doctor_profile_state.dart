import 'package:equatable/equatable.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';

enum DoctorProfileStatus { initial, loading, success, failure }

enum DoctorProfileUpdateStatus { initial, loading, success, failure }

enum DoctorStatusAction { initial, loading, success, failure }

class DoctorProfileState extends Equatable {
  final DoctorProfileStatus status;
  final DoctorProfileUpdateStatus updateStatus;
  final DoctorProfile? profile;
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
    DoctorProfile? profile,
    DoctorStatus? newDoctorStatus,
    DoctorStatusAction? doctorStatus,
    String? errorMessage,
    String? updateMessage,
    bool clearError = false,
    bool clearUpdateMessage = false,
  }) {
    return DoctorProfileState(
      status: status ?? this.status,
      updateStatus: updateStatus ?? this.updateStatus,
      profile: profile ?? this.profile,
      newDoctorStatus: newDoctorStatus ?? this.newDoctorStatus,
      doctorStatus: doctorStatus ?? this.doctorStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      updateMessage: clearUpdateMessage
          ? ''
          : (updateMessage ?? this.updateMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    updateStatus,
    profile,
    updateMessage,
    errorMessage,
    doctorStatus,
    newDoctorStatus,
  ];
}
