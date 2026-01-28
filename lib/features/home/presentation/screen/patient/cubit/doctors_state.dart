import 'package:equatable/equatable.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import '../../../../data/models/doctor_model.dart';

class DoctorsState extends Equatable {
  final DoctorsStatus status;
  final List<DoctorModel> allDoctors;
  final List<DoctorModel> filteredDoctors;
  final String? errorMessage;

  const DoctorsState({
    this.status = DoctorsStatus.initial,
    this.allDoctors = const [],
    this.filteredDoctors = const [],
    this.errorMessage,
  });

  DoctorsState copyWith({
    DoctorsStatus? status,
    List<DoctorModel>? allDoctors,
    List<DoctorModel>? filteredDoctors,
    String? errorMessage,
  }) {
    return DoctorsState(
      status: status ?? this.status,
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, allDoctors, filteredDoctors, errorMessage];
}
