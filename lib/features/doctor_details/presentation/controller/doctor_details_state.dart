import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

abstract class DoctorDetailsState extends Equatable {
  const DoctorDetailsState();

  @override
  List<Object?> get props => [];
}

class DoctorDetailsInitial extends DoctorDetailsState {}

class DoctorDetailsLoading extends DoctorDetailsState {}

class DoctorDetailsSuccess extends DoctorDetailsState {
  final DoctorDetails doctorDetails;

  const DoctorDetailsSuccess(this.doctorDetails);

  @override
  List<Object?> get props => [doctorDetails];
}

class DoctorDetailsFailure extends DoctorDetailsState {
  final String message;

  const DoctorDetailsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
